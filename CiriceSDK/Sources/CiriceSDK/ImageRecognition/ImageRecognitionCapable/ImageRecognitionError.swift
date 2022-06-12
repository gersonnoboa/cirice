import Foundation

/// Error thrown by the `ImageRecognitionCapable` instance.
public enum ImageRecognitionError: Error, Equatable {
    /// Image provided is incorrect.
    case noImage

    /// No results obtained from the image recognition framework.
    case noResults

    /// The amount of examples extracted from the picture exceeds the maximum
    /// required by the integrator.
    case maximumExceeded

    /// Error raised by the image recognition framework.
    case internalError(String)
}
