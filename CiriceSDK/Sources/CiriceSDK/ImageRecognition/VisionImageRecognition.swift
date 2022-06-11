import Foundation
import Vision
import UIKit

typealias TextImageRecognitionCapableCompletion = ((Result<TextImageRecognitionResponse, Error>) -> Void)
typealias FaceImageRecognitionCapableCompletion = ((Result<FaceImageRecognitionResponse, Error>) -> Void)

final class VisionImageRecognition: ImageRecognitionCapable {
    func recognizedFaces(using request: FaceImageRecognitionRequest) async throws -> FaceImageRecognitionResponse {
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
}

extension VisionImageRecognition {
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

    private func recognizeTextHandler(request: VNRequest, error: Error?, completion: TextImageRecognitionCapableCompletion) {
        if let error = error {
            completion(.failure(
                VisionImageRecognitionError.visionError(error.localizedDescription)
            ))
            return
        }

        guard let observations = request.results as? [VNRecognizedTextObservation] else {
            completion(.failure(VisionImageRecognitionError.noResults))
            return
        }

        let recognizedStrings = observations.compactMap { observation in
            return observation.topCandidates(1).first?.string
        }

        let response = TextImageRecognitionResponse(texts: recognizedStrings)

        completion(.success(response))
    }
}

extension VisionImageRecognition {
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

    private func recognizeFaceHandler(
        visionRequest: VNRequest,
        faceImageRecognitionRequest: FaceImageRecognitionRequest,
        error: Error?,
        completion: FaceImageRecognitionCapableCompletion
    ) {
        if let error = error {
            completion(.failure(
                VisionImageRecognitionError.visionError(error.localizedDescription)
            ))
            return
        }

        guard let observations = visionRequest.results as? [VNFaceObservation] else {
            completion(.failure(VisionImageRecognitionError.noResults))
            return
        }

        if observations.count > faceImageRecognitionRequest.maximumAllowedFaceCount {
            completion(.failure(VisionImageRecognitionError.maximumExceeded))
            return
        }
        
        let recognizedFaces: [UIImage] = observations.compactMap { observation in
            let originalImage = faceImageRecognitionRequest.image
            
            guard let originalCgImage = originalImage.cgImage else { return nil }
            
            let originalImageSize  = faceImageRecognitionRequest.image.size
            let boundingBox = observation.boundingBox
            let croppedImageSize = CGSize(
                width: boundingBox.width * originalImageSize.width,
                height: boundingBox.height * originalImageSize.height
            )
            let croppedImageOrigin = CGPoint(
                x: boundingBox.minX * originalImageSize.width,
                y: (1 - observation.boundingBox.minY) * originalImageSize.height - croppedImageSize.height
            )
            let croppedImageRect = CGRect(origin: croppedImageOrigin, size: croppedImageSize)
            
            guard let croppedCgImage = originalCgImage.cropping(to: croppedImageRect) else { return nil }
            
            return UIImage(cgImage: croppedCgImage)
        }

        let response = FaceImageRecognitionResponse(faceImages: recognizedFaces)

        completion(.success(response))
    }
}

extension VisionImageRecognition {
    private func performRequests(_ requests: [VNImageBasedRequest], using image: UIImage) throws {
        guard let cgImage = image.cgImage else {
            throw VisionImageRecognitionError.noImage
        }
        
        let imageRequestHandler = VNImageRequestHandler(cgImage: cgImage)
        
        do {
            try imageRequestHandler.perform(requests)
        } catch {
            throw VisionImageRecognitionError.visionError(error.localizedDescription)
        }
    }
}
