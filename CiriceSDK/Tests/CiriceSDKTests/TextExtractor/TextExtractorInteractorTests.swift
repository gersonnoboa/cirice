import XCTest
@testable import CiriceSDK

class TextExtractorInteractorTest: XCTestCase {
    var interactor: TextExtractorInteractor?

    func testSuccess() async throws {
        let mock = ImageRecognitionCapableSuccessMock()
        interactor = TextExtractorInteractor(imageRecognitionCapable: mock)
        
        let request = TextExtractorRequest(image: UIImage.add)
        let actualResponse = try! await interactor?.getTexts(using: request)
        let expectedResponse = TextExtractorResponse(texts: ["Elamisluba"])
        
        XCTAssertEqual(expectedResponse, actualResponse)
    }
    
    func testFailure() async throws {
        let mock = ImageRecognitionCapableFailureMock()
        interactor = TextExtractorInteractor(imageRecognitionCapable: mock)
        
        let request = TextExtractorRequest(image: UIImage.add)
        
        do {
            let _ = try await interactor?.getTexts(using: request)
            XCTFail("Should not generate texts")
        } catch {
            XCTAssertEqual(error as? VisionImageRecognitionError, .noResults)
        }
    }
    
    func testLiveIsTheCorrectType() {
        XCTAssertTrue(TextExtractorInteractor.live is TextExtractorInteractor)
    }
}
