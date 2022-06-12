import Foundation

/// Response given by the `ImageRecognitionCapable` instance with
/// texts extracted from an image.
struct TextImageRecognitionResponse: Equatable {
    /// The texts detected by the instance of the
    /// `ImageRecognitionCapable` instance.
    let texts: [String]
}
