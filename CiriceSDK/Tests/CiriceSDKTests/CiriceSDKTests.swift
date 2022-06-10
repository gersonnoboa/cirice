import XCTest
@testable import CiriceSDK

final class CiriceSDKTests: XCTestCase {
    func testGetAllTextsSuccess() async {
        let mock = ImageRecognitionCapableSuccessMock()
        let interactor = TextExtractorInteractor(imageRecognitionCapable: mock)
        
        let sdk = CiriceSDK(textExtractorInteractable: interactor)
        let request = TextExtractorRequest(image: UIImage.add)
        let expectedTexts = ["Elamisluba"]
        let expectedResponse = TextExtractorResponse(texts: expectedTexts)
        
        do {
            let actualResponse = try await sdk.getAllTexts(using: request)
            XCTAssertEqual(expectedResponse, actualResponse)
        } catch {
            XCTFail("Should succeed")
        }
    }
    
    func testGetAllTextsError() async {
        let mock = ImageRecognitionCapableFailureMock()
        let interactor = TextExtractorInteractor(imageRecognitionCapable: mock)
        
        let sdk = CiriceSDK(textExtractorInteractable: interactor)
        let request = TextExtractorRequest(image: UIImage.add)
        
        do {
            let _ = try await sdk.getAllTexts(using: request)
            XCTFail("Should fail")
        } catch {
            XCTAssertTrue(error is CiriceError)
        }
    }
}
