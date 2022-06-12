import Foundation
import UIKit

/// Response given by the `ImageRecognitionCapable` instance with
/// faces extracted from an image.
struct FaceImageRecognitionResponse {
    /// The faces detected by the instance of the
    /// `ImageRecognitionCapable` instance.
    var faceImages: [UIImage]
}
