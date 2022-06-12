import Foundation

/// An error that is thrown by the CiriceSDK.
public enum CiriceError: Error, Equatable {
    /// An error that occurs when trying to extract text.
    case textExtractor(ImageRecognitionError)

    /// An error that occurs when trying to extract faces.
    case faceExtractor(ImageRecognitionError)

    /// An unknown error.
    case unknown
}
