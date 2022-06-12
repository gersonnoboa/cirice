import Foundation

/// Interactor protocol that deals with face extraction capabilities.
protocol FaceExtractorInteractable {
    /// Get the detected faces in an image by using a `ImageRecognitionCapable` instance.
    /// - Parameter request: The request to be sent to the `ImageRecognitionCapable` framework.
    /// - Returns: The encapsulated result of the `ImageRecognitionCapable` framework.
    /// - Throws: `ImageRecognitionError`
    func getFaces(using request: FaceExtractorRequest) async throws -> FaceExtractorResponse
}

extension FaceExtractorInteractable where Self == FaceExtractorInteractor {
    /// The interactor implementation that holds the production functionality. In this case,
    /// an instance of `FaceExtractorInteractor`.
    static var live: FaceExtractorInteractable { FaceExtractorInteractor() }
}

/// Interactor that deals with face extraction capabilities.
final class FaceExtractorInteractor: FaceExtractorInteractable {
    private let imageRecognitionCapable: ImageRecognitionCapable

    /// Initializes a new `FaceExtractorInteractor`.
    /// - Parameter imageRecognitionCapable: An object that implements the
    /// `ImageRecognitionCapable` protocol. By default, its value is `.live`.
    init(imageRecognitionCapable: ImageRecognitionCapable = .live) {
        self.imageRecognitionCapable = imageRecognitionCapable

    }

    /// Get the detected faces in an image using a `ImageRecognitionCapable` instance.
    /// - Parameter request: The request to be sent to the `ImageRecognitionCapable` instance.
    /// - Returns: The encapsulated result of the `ImageRecognitionCapable` instance.
    /// - Throws: `ImageRecognitionError`
    func getFaces(using request: FaceExtractorRequest) async throws -> FaceExtractorResponse {
        let imageRecognitionRequest = FaceImageRecognitionRequest(
            image: request.image,
            maximumAllowedFaceCount: request.maximumAllowedFaceCount
        )
        
        let imageRecognitionResponse = try await imageRecognitionCapable.recognizedFaces(
            using: imageRecognitionRequest
        )
        let textExtractorResponse = FaceExtractorResponse(
            faceImages: imageRecognitionResponse.faceImages
        )

        return textExtractorResponse
    }
}
