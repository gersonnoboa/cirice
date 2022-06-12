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

    func testGetFaceSuccess() async {
        let mock = ImageRecognitionCapableSuccessMock()
        let interactor = FaceExtractorInteractor(imageRecognitionCapable: mock)
        let sdk = CiriceSDK(faceExtractorInteractable: interactor)

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

    func testGetFacesError() async {
        let mock = ImageRecognitionCapableFailureMock()
        let interactor = FaceExtractorInteractor(imageRecognitionCapable: mock)
        let sdk = CiriceSDK(faceExtractorInteractable: interactor)

        guard let image = UIImage(named: "family", in: Bundle.module, with: .none) else {
            XCTFail("Image not loaded")
            return
        }

        let request = FaceExtractorRequest(image: image)

        do {
            let _ = try await sdk.getFaces(using: request)
            XCTFail("Should fail")
        } catch {
            XCTAssertTrue(error is CiriceError)
        }
    }
}
