import UIKit

protocol CiriceSDKCapable {
    func getAllTexts(using request: TextExtractorRequest) async throws -> TextExtractorResponse
}

public struct CiriceSDK: CiriceSDKCapable {
    private let textExtractorInteractable: TextExtractorInteractable

    public init() {
        self.textExtractorInteractable = .live
    }

    init(textExtractorInteractable: TextExtractorInteractable) {
        self.textExtractorInteractable = textExtractorInteractable
    }

    public func getAllTexts(using request: TextExtractorRequest) async throws -> TextExtractorResponse {
        return try await textExtractorInteractable.getTexts(using: request)
    }
}
