import Foundation
import UIKit

/// Interactor protocol that deals with text extraction from an image.
protocol TextExtractorInteractable {
    /// Get the detected texts in an image by using a `ImageRecognitionCapable` instance.
    /// - Parameter request: The request to be sent to the `ImageRecognitionCapable` framework.
    /// - Returns: The encapsulated result of the `ImageRecognitionCapable` framework.
    /// - Throws: `ImageRecognitionError`
    func getTexts(using request: TextExtractorRequest) async throws -> TextExtractorResponse
}

extension TextExtractorInteractable where Self == TextExtractorInteractor {
    /// The interactor implementation that holds the production functionality. In this case,
    /// an instance of `TextExtractorInteractor`.
    static var live: TextExtractorInteractable { TextExtractorInteractor() }
}

/// Interactor that deals with text extraction from an image.
class TextExtractorInteractor: TextExtractorInteractable {
    private let imageRecognitionCapable: ImageRecognitionCapable

    /// Initializes a new `TextExtractorInteractor`.
    /// - Parameter imageRecognitionCapable: An object that implements the
    /// `ImageRecognitionCapable` protocol. By default, its value is `.live`.
    init(imageRecognitionCapable: ImageRecognitionCapable = .live) {
        self.imageRecognitionCapable = imageRecognitionCapable
    }

    /// Get the detected texts in an image using a `ImageRecognitionCapable` instance.
    /// - Parameter request: The request to be sent to the `ImageRecognitionCapable` instance.
    /// - Returns: The encapsulated result of the `ImageRecognitionCapable` instance.
    /// - Throws: `ImageRecognitionError`
    func getTexts(using request: TextExtractorRequest) async throws -> TextExtractorResponse {
        let imageRecognitionRequest = TextImageRecognitionRequest(image: request.image)
        let imageRecognitionResponse = try await imageRecognitionCapable.recognizedTexts(using: imageRecognitionRequest)
        let textExtractorResponse = TextExtractorResponse(texts: imageRecognitionResponse.texts)

        return textExtractorResponse

    }
}
