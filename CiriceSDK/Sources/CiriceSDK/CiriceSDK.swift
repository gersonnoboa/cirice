import UIKit

protocol CiriceSDKCapable {
    func getAllTexts(using request: TextExtractorRequest) async throws -> TextExtractorResponse
    func getFaces(using request: FaceExtractorRequest) async throws -> FaceExtractorResponse
}

public struct CiriceSDK: CiriceSDKCapable {
    private let textExtractorInteractable: TextExtractorInteractable
    private let faceExtractorInteractable: FaceExtractorInteractable

    public init() {
        self.textExtractorInteractable = .live
        self.faceExtractorInteractable = .live
    }

    init(
        textExtractorInteractable: TextExtractorInteractable,
        faceExtractorInteractable: FaceExtractorInteractable
    ) {
        self.textExtractorInteractable = textExtractorInteractable
        self.faceExtractorInteractable = faceExtractorInteractable
    }

    public func getAllTexts(using request: TextExtractorRequest) async throws -> TextExtractorResponse {
        do {            
            return try await textExtractorInteractable.getTexts(using: request)
        } catch let error as VisionImageRecognitionError {
            throw CiriceError.textExtractor(error)
        } catch {
            throw CiriceError.unknown
        }
    }
    
    public func getFaces(using request: FaceExtractorRequest) async throws -> FaceExtractorResponse {
        do {
            return try await faceExtractorInteractable.getFaces(using: request)
        } catch let error as VisionImageRecognitionError {
            throw CiriceError.faceExtractor(error)
        } catch {
            throw CiriceError.unknown
        }
    }
}
