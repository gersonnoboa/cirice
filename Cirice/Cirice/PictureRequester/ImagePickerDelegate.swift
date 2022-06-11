import Foundation
import UIKit

final class ImagePickerDelegate: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var onImagePicked: ((UIImage) -> Void)?
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
