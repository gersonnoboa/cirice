import UIKit

/// Protocol that contains the SDK functionality.
protocol CiriceSDKCapable {
    /// Get the detected texts in an image using a `ImageRecognitionCapable` instance.
    /// - Parameter request: The request to be sent to the `ImageRecognitionCapable` instance.
    /// - Returns: The encapsulated result of the `ImageRecognitionCapable` instance.
    /// - Throws: `CiriceError`
    func getAllTexts(
        using request: TextExtractorRequest
    ) async throws -> TextExtractorResponse

    /// Get the detected faces in an image using a `ImageRecognitionCapable` instance.
    /// - Parameter request: The request to be sent to the `ImageRecognitionCapable` instance.
    /// - Returns: The encapsulated result of the `ImageRecognitionCapable` instance.
    /// - Throws: `CiriceError`
    func getFaces(
        using request: FaceExtractorRequest
    ) async throws -> FaceExtractorResponse
}

public struct CiriceSDK: CiriceSDKCapable {
    private let textExtractorInteractable: TextExtractorInteractable
    private let faceExtractorInteractable: FaceExtractorInteractable

    /// Initializes the SDK with all the interactables set to the production instances.
    /// This is the only way the integrator is meant to initialize the CiriceSDK.
    public init() {
        self.textExtractorInteractable = .live
        self.faceExtractorInteractable = .live
    }

    /// Initializes the SDK with the specified interactables. This is meant to be used
    /// for all kinds of tests.
    /// - Parameters:
    ///   - textExtractorInteractable: The interactor that implements text extraction functionality.
    ///   Its default value is `.live`.
    ///   - faceExtractorInteractable: The interactor that implements face extraction functionality.
    ///   Its default value is `.live`.
    init(
        textExtractorInteractable: TextExtractorInteractable = .live,
        faceExtractorInteractable: FaceExtractorInteractable = .live
    ) {
        self.textExtractorInteractable = textExtractorInteractable
        self.faceExtractorInteractable = faceExtractorInteractable
    }

    /// Get the detected texts in an image.
    /// - Parameter request: The request to be used.
    /// - Returns: A result with all the extracted texts.
    /// - Throws: `CiriceError`
    public func getAllTexts(
        using request: TextExtractorRequest
    ) async throws -> TextExtractorResponse {
        do {            
            return try await textExtractorInteractable.getTexts(using: request)
        } catch let error as ImageRecognitionError {
            throw CiriceError.textExtractor(error)
        } catch {
            throw CiriceError.unknown
        }
    }

    /// Get the detected faces in an image. The maximum amount of faces is determined
    /// by the `maximumAllowedFaceCount` property in the request.
    /// - Parameter request: The request to be used.
    /// - Returns: A result with all the extracted faces.
    /// - Throws: `CiriceError`
    public func getFaces(
        using request: FaceExtractorRequest
    ) async throws -> FaceExtractorResponse {
        do {
            return try await faceExtractorInteractable.getFaces(using: request)
        } catch let error as ImageRecognitionError {
            throw CiriceError.faceExtractor(error)
        } catch {
            throw CiriceError.unknown
        }
    }
}
