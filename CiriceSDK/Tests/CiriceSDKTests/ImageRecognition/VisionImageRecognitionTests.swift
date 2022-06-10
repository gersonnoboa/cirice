import Foundation
@testable import CiriceSDK
import XCTest

final class VisionImageRecognitionTests: XCTestCase {
    var visionImageRecognition = VisionImageRecognition()
    
    func testSuccess() async {
        guard let image = UIImage(named: "test-text", in: Bundle.module, with: .none) else {
            XCTFail("Image not loaded")
            return
        }
        
        let request = TextImageRecognitionRequest(image: image)
        let expectedTexts = ["The quick", "brown fox", "jumps over", "the lazy dog."]
        let expectedResponse = TextImageRecognitionResponse(texts: expectedTexts)
        
        do {
            let actualResponse = try await visionImageRecognition.recognizedTexts(using: request)
            XCTAssertEqual(expectedResponse, actualResponse)
        } catch {
            XCTFail("Should succeed")
        }
    }
    
    func testSuccessWithTextlessImage() async {
        let request = TextImageRecognitionRequest(image: UIImage.add)
        do {
            let response = try await visionImageRecognition.recognizedTexts(using: request)
            XCTAssertEqual(response.texts, [])
        } catch {
            XCTFail("Should succeed")
        }
    }
    
    func testLiveIsTheCorrectType() {
        XCTAssertTrue(VisionImageRecognition.live is VisionImageRecognition)
    }
}
