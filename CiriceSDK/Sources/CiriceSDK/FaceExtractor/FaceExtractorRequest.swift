import Foundation
import UIKit

/// Request to be sent to an`ImageRecognitionCapable` instance to extract faces.
public struct FaceExtractorRequest {
    /// The picture taken by the user.
    let image: UIImage

    /// The maximum number of faces allowed to be identified in the picture.
    /// By default, the value is 1 if using. the public initializer.
    let maximumAllowedFaceCount: Int

    /// Initializes a request to detect faces in a picture. This request is meant to be sent to an instance of
    /// the `ImageRecognitionCapable` protocol.
    /// - Parameters:
    ///   - image: The picture taken by the user.
    ///   - maximumAllowedFaceCount: The maximum number of faces allowed to be
    ///   identified in the picture. By default, the value is 1.
    public init(image: UIImage, maximumAllowedFaceCount: Int = 1) {
        self.image = image
        self.maximumAllowedFaceCount = maximumAllowedFaceCount
    }
}
