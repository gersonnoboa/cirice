import Foundation
import UIKit

/// Request to be sent to an `ImageRecognitionCapable` instance to extract texts.
public struct TextExtractorRequest {
    /// The picture taken by the user.
    let image: UIImage

    /// Initializes a request to detect texts in a picture. This request is meant to be sent to an instance of
    /// the `ImageRecognitionCapable` protocol.
    /// - Parameters:
    ///   - image: The picture taken by the user.
    public init(image: UIImage) {
        self.image = image
    }
}
