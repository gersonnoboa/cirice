import Foundation
import UIKit
import CiriceSDK

/// Interface that describes the VIP lifecycle of the picture requester view controller.
protocol PictureRequesterControllable: AnyObject {
    /// Shows the texts extracted by the CiriceSDK from the image.
    /// - Parameters:
    ///   - text: Formatted text to be displayed on screen.
    ///   - originalImage: Image sent to the CiriceSDK for extraction.
    func showAllTexts(_ text: String, originalImage: UIImage)

    /// Shows the texts extracted by the CiriceSDK from the image.
    /// - Parameters:
    ///   - face: Face image to be displayed on screen.
    ///   - originalImage: Image sent to the CiriceSDK for extraction.
    func showFace(_ faceImage: UIImage, originalImage: UIImage)


    /// Shows an error in an alert. Will always show "Error" as title, and will have a
    /// button with the "OK" text on it to dismiss it.
    /// - Parameter message: Message to be shown by the alert.
    func showError(message: String)
}

/// View controller that shows the picture requester functionality on screen.
final class PictureRequesterViewController: UIViewController {
    /// Shows the picture taken by the user
    @IBOutlet weak var pictureImageView: UIImageView!

    /// Shows the image recognition result when the request type is text.
    @IBOutlet weak var resultTextView: UITextView!

    /// Shows the image recognition result when the request type is face.
    @IBOutlet weak var resultImageView: UIImageView!

    /// Holds all the views in the screen, except for the activity indicator.
    @IBOutlet weak var stackView: UIStackView!

    /// Activity indicator to be shown while the CiriceSDK does its functionality.
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    /// The request type that configures which kind of result is shown to the user.
    var requestType: RequestType = .texts

    /// The delegate for the UIImagePickerController.
    let imagePickerDelegate = ImagePickerDelegate()

    var interactable: PictureRequesterInteractable?


    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
        takePicture()
    }

    /// Configure initial view controller state.
    private func configureViewController() {
        title = "Extraction"

        stackView.isHidden = true
    }

    /// Take a picture using an UIImagePickerController.
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

    /// Calls the CiriceSDK to extract texts or faces.
    /// - Parameter image: The image in which operations will be executed.
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
    /// Shows the texts extracted by the CiriceSDK from the image.
    /// - Parameters:
    ///   - text: Formatted text to be displayed on screen.
    ///   - originalImage: Image sent to the CiriceSDK for extraction.
    func showAllTexts(_ text: String, originalImage: UIImage) {
        activityIndicator.stopAnimating()
        stackView.isHidden = false

        resultImageView.isHidden = true
        resultTextView.text = text
        pictureImageView.image = originalImage
    }

    /// Shows the face extracted by the CiriceSDK from the image.
    /// - Parameters:
    ///   - face: Face image to be displayed on screen.
    ///   - originalImage: Image sent to the CiriceSDK for extraction.
    func showFace(_ faceImage: UIImage, originalImage: UIImage) {
        activityIndicator.stopAnimating()
        stackView.isHidden = false

        resultTextView.isHidden = true
        resultImageView.image = faceImage
        pictureImageView.image = originalImage
    }

    /// Shows an error in an alert. Will always show "Error" as title, and will have a
    /// button with the "OK" text on it to dismiss it.
    /// - Parameter message: Message to be shown by the alert.
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
