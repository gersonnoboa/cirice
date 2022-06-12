import Foundation

/// A request type to be sent to `PictureRequesterViewController`.
enum RequestType: Int {
    /// View controller should have the text extraction interface.
    case texts = 0

    /// View controller should have the face extraction interface.
    case face
}
