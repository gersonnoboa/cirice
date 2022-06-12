import Foundation
import UIKit

/// Request to be sent to an `ImageRecognitionCapable` instance to extract faces.
struct FaceImageRecognitionRequest {
    /// The picture taken by the user.
    let image: UIImage

    /// The maximum number of faces allowed to be identified in the picture. By default, the value is 1.
    let maximumAllowedFaceCount: Int
}
