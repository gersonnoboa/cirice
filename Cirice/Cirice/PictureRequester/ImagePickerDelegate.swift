import Foundation
import UIKit

/// Class to be used for when using an UIImagePickerController.
final class ImagePickerDelegate: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    /// Closure called when an image has been picked.
    var onImagePicked: ((UIImage) -> Void)?

    /// Closure called when the picker has been cancelled or the image selected is invalid.
    var onCancel: (() -> Void)?

    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        picker.dismiss(animated: true)

        guard let image = info[.originalImage] as? UIImage else {
            onCancel?()
            return
        }

        onImagePicked?(image)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        onCancel?()
    }
}
