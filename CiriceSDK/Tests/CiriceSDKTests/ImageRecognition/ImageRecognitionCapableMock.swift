import Foundation
@testable import CiriceSDK

class ImageRecognitionCapableSuccessMock: ImageRecognitionCapable {
    func recognizedTexts(
        using request: TextImageRecognitionRequest
    ) async throws -> TextImageRecognitionResponse {
        return TextImageRecognitionResponse(texts: ["Elamisluba"])
    }
}

class ImageRecognitionCapableFailureMock: ImageRecognitionCapable {
    func recognizedTexts(
        using request: TextImageRecognitionRequest
    ) async throws -> TextImageRecognitionResponse {
        throw VisionImageRecognitionError.noResults
    }
}
