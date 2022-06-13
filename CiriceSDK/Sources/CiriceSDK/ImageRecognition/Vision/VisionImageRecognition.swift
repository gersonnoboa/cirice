import Foundation
import Vision
import UIKit

typealias TextImageRecognitionCapableCompletion = (
    (Result<TextImageRecognitionResponse, Error>) -> Void
)
typealias FaceImageRecognitionCapableCompletion = (
    (Result<FaceImageRecognitionResponse, Error>) -> Void
)

/// This class wraps around the Vision framework in order to conform to `ImageRecognitionCapable`
/// and send/receive generic requests/responses. If the need arises to use a different framework than
/// Vision, this class can be replaced, as long as the new one implements `ImageRecognitionCapable`.
final class VisionImageRecognition: ImageRecognitionCapable {
    /// Gets all the texts recognized from an image.
    /// - Parameter request: The request to be used for the extraction.
    /// - Returns: The response that encapsulates the result provided by
    /// the image recognition framework.
    /// - Throws: `ImageRecognitionError`
    func recognizedTexts(
        using request: TextImageRecognitionRequest
    ) async throws -> TextImageRecognitionResponse {
        return try await withCheckedThrowingContinuation { continuation in
            recognizedTexts(request: request) { result in
                switch result {
                case .success(let response):
                    continuation.resume(returning: response)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    /// Gets the faces recognized from an image.
    /// - Parameter request: The request to be used for the extraction.
    /// - Returns: The response that encapsulates the result provided by
    /// the image recognition framework.
    /// - Throws: `ImageRecognitionError`
    func recognizedFaces(
        using request: FaceImageRecognitionRequest
    ) async throws -> FaceImageRecognitionResponse {
        return try await withCheckedThrowingContinuation { continuation in
            recognizedFaces(request: request) { result in
                switch result {
                case .success(let response):
                    continuation.resume(returning: response)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

extension VisionImageRecognition {
    /// Gets all the texts recognized from an image. This is used by the continuation above
    /// to make the Vision framework usable with async/await.
    /// - Parameters:
    ///   - request: The request to be used for the extraction.
    ///   - completion: The completion to be called with the result of the operation.
    private func recognizedTexts(
        request: TextImageRecognitionRequest,
        completion: @escaping TextImageRecognitionCapableCompletion
    ) {
        let textRequest = VNRecognizeTextRequest { [weak self] request, error in
            self?.recognizeTextHandler(request: request, error: error, completion: completion)
        }
        
        do {
            try performRequests([textRequest], using: request.image)
        } catch {
            completion(.failure(error))
        }
    }

    /// The handler to be called after the `VNRecognizeTextRequest` is done.
    /// - Parameters:
    ///   - request: The request sent to the Vision framework.
    ///   - error: A potential error raised by the Vision framework.
    ///   - completion: The completion to be called with the result of the operation.
    private func recognizeTextHandler(
        request: VNRequest,
        error: Error?,
        completion: TextImageRecognitionCapableCompletion
    ) {
        if let error = error {
            completion(.failure(
                ImageRecognitionError.internalError(error.localizedDescription)
            ))
            return
        }

        guard let observations = request.results as? [VNRecognizedTextObservation] else {
            completion(.failure(ImageRecognitionError.noResults))
            return
        }

        let recognizedStrings = observations.compactMap { observation in
            return observation.topCandidates(1).first?.string
        }

        if recognizedStrings.isEmpty {
            completion(.failure(ImageRecognitionError.noResults))
            return
        }

        let response = TextImageRecognitionResponse(texts: recognizedStrings)

        completion(.success(response))
    }
}

extension VisionImageRecognition {
    /// Gets all the faces recognized from an image. This is used by the continuation above
    /// to make the Vision framework usable with async/await.
    /// - Parameters:
    ///   - request: The request to be used for the extraction.
    ///   - completion: The completion to be called with the result of the operation.
    private func recognizedFaces(
        request: FaceImageRecognitionRequest,
        completion: @escaping FaceImageRecognitionCapableCompletion
    ) {
        let faceRequest = VNDetectFaceRectanglesRequest { visionRequest, error in
            self.recognizeFaceHandler(
                visionRequest: visionRequest,
                faceImageRecognitionRequest: request,
                error: error,
                completion: completion
            )
        }
        
        do {
            try performRequests([faceRequest], using: request.image)
        } catch {
            completion(.failure(error))
        }
    }

    /// The handler to be called after the `VNDetectFaceRectanglesRequest` is done.
    /// - Parameters:
    ///   - visionRequest: The request to be used for the extraction.
    ///   - faceImageRecognitionRequest: The initial request sent by the interactor.
    ///   - error: A potential error raised by the Vision framework.
    ///   - completion: The completion to be called with the result of the operation.
    private func recognizeFaceHandler(
        visionRequest: VNRequest,
        faceImageRecognitionRequest: FaceImageRecognitionRequest,
        error: Error?,
        completion: FaceImageRecognitionCapableCompletion
    ) {
        if let error = error {
            completion(.failure(
                ImageRecognitionError.internalError(error.localizedDescription)
            ))
            return
        }

        guard let observations = visionRequest.results as? [VNFaceObservation] else {
            completion(.failure(ImageRecognitionError.noResults))
            return
        }

        if observations.count > faceImageRecognitionRequest.maximumAllowedFaceCount {
            completion(.failure(ImageRecognitionError.maximumExceeded))
            return
        }
        
        let recognizedFaces: [UIImage] = observations.compactMap { observation in
            let originalImage = faceImageRecognitionRequest.image
            
            guard
                let originalCgImage = originalImage.cgImage,
                let croppedCgImage = croppedImage(
                    using: observation.boundingBox,
                    image: originalCgImage
                )
            else { return nil }

            return UIImage(
                cgImage: croppedCgImage,
                scale: 1.0,
                orientation: originalImage.imageOrientation
            )
        }

        let response = FaceImageRecognitionResponse(faceImages: recognizedFaces)

        completion(.success(response))
    }

    /// The `boundingRect` returned by the Vision framework is at scale. This method
    /// adjusts it to correspond to a frame that wraps around the detected face, and then
    /// gets the image from the original image.
    /// - Parameters:
    ///   - boundingBox: The `boundingBox` extracted from Vision's observation.
    ///   - image: The initial `CGImage`.
    /// - Returns: A `CGImage` that contains the detected face.
    private func croppedImage(
        using boundingBox: CGRect,
        image: CGImage
    ) -> CGImage? {
        let width = boundingBox.width * CGFloat(image.width)
        let height = boundingBox.height * CGFloat(image.height)
        let x = boundingBox.origin.x * CGFloat(image.width)
        let y = (1 - boundingBox.origin.y) * CGFloat(image.height) - height

        let croppingRect = CGRect(x: x, y: y, width: width, height: height)
        let image = image.cropping(to: croppingRect)
        return image
    }
}

extension VisionImageRecognition {
    /// Execute the requests sent using the Vision framework.
    /// - Parameters:
    ///   - requests: The requests to be executed.
    ///   - image: The image in which the requests are going to be executed.
    private func performRequests(_ requests: [VNImageBasedRequest], using image: UIImage) throws {
        guard let cgImage = image.cgImage else {
            throw ImageRecognitionError.noImage
        }

        let imageRequestHandler = VNImageRequestHandler(
            cgImage: cgImage
        )
        
        do {
            try imageRequestHandler.perform(requests)
        } catch {
            throw ImageRecognitionError.internalError(error.localizedDescription)
        }
    }
}
