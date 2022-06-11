import Foundation
@testable import CiriceSDK
import XCTest

final class VisionImageRecognitionTests: XCTestCase {
    var visionImageRecognition = VisionImageRecognition()
    
    func testTextExtractionSuccess() async {
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
    
    func testTextExtractionSuccessWithTextlessImage() async {
        let request = TextImageRecognitionRequest(image: UIImage.add)
        do {
            let response = try await visionImageRecognition.recognizedTexts(using: request)
            XCTAssertEqual(response.texts, [])
        } catch {
            XCTFail("Should succeed")
        }
    }
    
    func testFaceExtractionSuccess() async {
        guard let image = UIImage(named: "max", in: Bundle.module, with: .none) else {
            XCTFail("Image not loaded")
            return
        }
        
        let request = FaceImageRecognitionRequest(
            image: image,
            maximumAllowedFaceCount: 1
        )
        
        do {
            let response = try await visionImageRecognition.recognizedFaces(using: request)
            XCTAssertTrue(response.faceImages.count == 1)
        } catch {
            XCTFail("Should succeed")
        }
    }
    
    func testFaceExtractionMaximumFaceCountFailure() async {
        guard let image = UIImage(named: "family", in: Bundle.module, with: .none) else {
            XCTFail("Image not loaded")
            return
        }
        
        let request = FaceImageRecognitionRequest(
            image: image,
            maximumAllowedFaceCount: 1
        )
        
        do {
            let _ = try await visionImageRecognition.recognizedFaces(using: request)
            XCTFail("Should fail")
        } catch {
            XCTAssertEqual(
                error as! VisionImageRecognitionError,
                VisionImageRecognitionError.maximumExceeded
            )
        }
    }
    
    func testLiveIsTheCorrectType() {
        XCTAssertTrue(VisionImageRecognition.live is VisionImageRecognition)
    }
}
