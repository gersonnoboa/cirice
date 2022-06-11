import Foundation
import UIKit
import CiriceSDK

protocol PictureRequesterControllable: AnyObject {
    func showAllTexts(_ text: String, originalImage: UIImage)
    func showFace(_ faceImage: UIImage, originalImage: UIImage)
    func showError(message: String)
}

final class PictureRequesterViewController: UIViewController {
    enum PictureRequesterError: Error {
        case invalidImage
    }

    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var resultTextView: UITextView!
    @IBOutlet weak var resultImageView: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var requestType: RequestType = .texts
    var interactable: PictureRequesterInteractable?
    let imagePickerDelegate = ImagePickerDelegate()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
        takePicture()
    }

    private func configureViewController() {
        title = "Extraction"

        stackView.isHidden = true
    }

    private func takePicture() {
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            showError(message: "Camera is not available.")
            return
        }

        imagePickerDelegate.onImagePicked = { [weak self] image in
            Task {
                await self?.startExtraction(using: image)
            }
        }

        imagePickerDelegate.onCancel = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }

        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .camera
        imagePickerController.allowsEditing = false
        imagePickerController.cameraCaptureMode = .photo
        imagePickerController.cameraFlashMode = .off
        imagePickerController.delegate = imagePickerDelegate

        present(imagePickerController, animated: true)
    }

    private func startExtraction(using image: UIImage) async {
        switch requestType {
        case .texts:
            await interactable?.executeGetAllTexts(using: image)
        case .face:
            await interactable?.executeGetFace(using: image)
        }
    }
}

extension PictureRequesterViewController: PictureRequesterControllable {
    func showAllTexts(_ text: String, originalImage: UIImage) {
        activityIndicator.stopAnimating()
        stackView.isHidden = false

        resultImageView.isHidden = true
        resultTextView.text = text
        pictureImageView.image = originalImage
    }

    func showFace(_ faceImage: UIImage, originalImage: UIImage) {
        activityIndicator.stopAnimating()
        stackView.isHidden = false

        resultTextView.isHidden = true
        resultImageView.image = faceImage
        pictureImageView.image = originalImage
    }

    func showError(message: String) {
        stackView.isHidden = true
        activityIndicator.stopAnimating()

        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )

        let action = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
        alert.addAction(action)

        present(alert, animated: true)
    }
}

extension UIImagePickerController {
    open override var childForStatusBarHidden: UIViewController? {
        return nil
    }

    open override var prefersStatusBarHidden: Bool {
        return true
    }
}
