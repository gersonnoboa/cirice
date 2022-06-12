import Foundation
import UIKit

/// Request to be sent to am `ImageRecognitionCapable` instance to extract texts.
struct TextImageRecognitionRequest {
    /// The picture taken by the user.
    let image: UIImage
}
