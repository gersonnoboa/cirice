import Foundation

protocol ImageRecognitionCapable {
    func recognizedTexts(
        using request: TextImageRecognitionRequest
    ) async throws -> TextImageRecognitionResponse
    
    func recognizedFaces(
        using request: FaceImageRecognitionRequest
    ) async throws -> FaceImageRecognitionResponse
}

extension ImageRecognitionCapable where Self == VisionImageRecognition {
    static var live: ImageRecognitionCapable { VisionImageRecognition() }
}
