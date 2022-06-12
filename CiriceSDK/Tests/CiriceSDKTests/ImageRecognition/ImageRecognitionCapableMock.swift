import Foundation
import UIKit
@testable import CiriceSDK

class ImageRecognitionCapableSuccessMock: ImageRecognitionCapable {
    func recognizedFaces(
        using request: FaceImageRecognitionRequest
    ) async throws -> FaceImageRecognitionResponse {
        return FaceImageRecognitionResponse(faceImages: [UIImage.add])
    }
    
    func recognizedTexts(
        using request: TextImageRecognitionRequest
    ) async throws -> TextImageRecognitionResponse {
        return TextImageRecognitionResponse(texts: ["Elamisluba"])
    }
}

class ImageRecognitionCapableFailureMock: ImageRecognitionCapable {
    func recognizedFaces(
        using request: FaceImageRecognitionRequest
    ) async throws -> FaceImageRecognitionResponse {
        throw ImageRecognitionError.noResults
    }
    
    func recognizedTexts(
        using request: TextImageRecognitionRequest
    ) async throws -> TextImageRecognitionResponse {
        throw ImageRecognitionError.noResults
    }
}
