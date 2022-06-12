import Foundation
import XCTest
@testable import CiriceSDK

final class CiriceSDKIntegrationTests: XCTestCase {
    let sdk = CiriceSDK()

    func testTextExtraction() async {
        guard let image = UIImage(named: "test-text", in: Bundle.module, with: .none) else {
            XCTFail("Image not loaded")
            return
        }
        let request = TextExtractorRequest(image: image)
        let expectedTexts = ["The quick", "brown fox", "jumps over", "the lazy dog."]
        let expectedResponse = TextExtractorResponse(texts: expectedTexts)

        do {
            let actualResponse = try await sdk.getAllTexts(using: request)
            XCTAssertEqual(expectedResponse, actualResponse)
        } catch {
            XCTFail("Should succeed")
        }
    }

    func testOneFaceExtraction() async {
        guard let image = UIImage(named: "max", in: Bundle.module, with: .none) else {
            XCTFail("Image not loaded")
            return
        }
        
        let request = FaceExtractorRequest(image: image)

        do {
            let response = try await sdk.getFaces(using: request)
            XCTAssertTrue(response.faceImages.count == 1)
        } catch {
            XCTFail("Should succeed")
        }
    }

    func testMultipleFaceExtraction() async {
        guard let image = UIImage(named: "family", in: Bundle.module, with: .none) else {
            XCTFail("Image not loaded")
            return
        }

        let request = FaceExtractorRequest(image: image)

        do {
            let _ = try await sdk.getFaces(using: request)
            XCTFail("Should fail")
        } catch CiriceError.faceExtractor(let error) {
            XCTAssertEqual(
                error,
                ImageRecognitionError.maximumExceeded
            )
        } catch {
            XCTFail("Should have been caught")
        }
    }
}
