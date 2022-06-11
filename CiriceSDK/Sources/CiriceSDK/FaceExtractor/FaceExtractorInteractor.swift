import Foundation

protocol FaceExtractorInteractable {
    func getFaces(using request: FaceExtractorRequest) async throws -> FaceExtractorResponse
}

extension FaceExtractorInteractable where Self == FaceExtractorInteractor {
    static var live: FaceExtractorInteractable { FaceExtractorInteractor() }
}

final class FaceExtractorInteractor: FaceExtractorInteractable {
    private let imageRecognitionCapable: ImageRecognitionCapable

    init(imageRecognitionCapable: ImageRecognitionCapable = .live) {
        self.imageRecognitionCapable = imageRecognitionCapable
    }
    
    func getFaces(using request: FaceExtractorRequest) async throws -> FaceExtractorResponse {
        let imageRecognitionRequest = FaceImageRecognitionRequest(
            image: request.image, maximumAllowedFaceCount:
                request.maximumAllowedFaceCount
        )
        
        let imageRecognitionResponse = try await imageRecognitionCapable.recognizedFaces(using: imageRecognitionRequest)
        let textExtractorResponse = FaceExtractorResponse(faceImages: imageRecognitionResponse.faceImages)

        return textExtractorResponse
    }
}
