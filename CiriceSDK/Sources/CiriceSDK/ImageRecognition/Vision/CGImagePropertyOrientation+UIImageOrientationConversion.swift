import Foundation
import UIKit

extension CGImagePropertyOrientation {
    /// UIImage.Orientation and CGImagePropertyOrientation have the same names
    /// for their enum cases, but the underlying `rawValue` is different. Thus, we need
    /// to convert from one to the other.
    /// - Parameter uiOrientation: The orientation of an `UIImage`.
    init(_ uiOrientation: UIImage.Orientation) {
        switch uiOrientation {
        case .up: self = .up
        case .upMirrored: self = .upMirrored
        case .down: self = .down
        case .downMirrored: self = .downMirrored
        case .left: self = .left
        case .leftMirrored: self = .leftMirrored
        case .right: self = .right
        case .rightMirrored: self = .rightMirrored
        @unknown default: self = .up
        }
    }
}
