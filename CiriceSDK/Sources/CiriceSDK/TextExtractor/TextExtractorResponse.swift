import Foundation

/// Response to be sent to the integrator with texts extracted from an image.
public struct TextExtractorResponse: Equatable {
    /// The texts detected by the instance of the object that
    /// implements`ImageRecognitionCapable`.
    public let texts: [String]
}
