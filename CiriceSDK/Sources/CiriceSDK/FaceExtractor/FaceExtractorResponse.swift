import Foundation
import UIKit

/// Response to be sent to the integrator with faces extracted from an image.
public struct FaceExtractorResponse: Equatable {
    /// The faces detected by the instance of the object that
    /// implements`ImageRecognitionCapable`.
    public let faceImages: [UIImage]
}
