import Foundation
import XCTest
@testable import CiriceSDK

final class FaceExtractorInteractorTests: XCTestCase {
    var interactor: FaceExtractorInteractor?

    func testSuccess() async throws {
        let mock = ImageRecognitionCapableSuccessMock()
        interactor = FaceExtractorInteractor(imageRecognitionCapable: mock)
        
        let request = FaceExtractorRequest(image: UIImage.add)
        let actualResponse = try! await interactor?.getFaces(using: request)
        let expectedResponse = FaceExtractorResponse(faceImages: [UIImage.add])
        
        XCTAssertEqual(expectedResponse, actualResponse)
    }
    
    func testFailure() async throws {
        let mock = ImageRecognitionCapableFailureMock()
        interactor = FaceExtractorInteractor(imageRecognitionCapable: mock)
        
        let request = FaceExtractorRequest(image: UIImage.add)
        
        do {
            let _ = try await interactor?.getFaces(using: request)
            XCTFail("Should not generate texts")
        } catch {
            XCTAssertEqual(error as? ImageRecognitionError, .noResults)
        }
    }
    
    func testLiveIsTheCorrectType() {
        XCTAssertTrue(FaceExtractorInteractor.live is FaceExtractorInteractor)
    }
}
