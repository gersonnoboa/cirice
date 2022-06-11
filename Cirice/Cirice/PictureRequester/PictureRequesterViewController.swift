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

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()

        Task {
            await startExtraction()
        }
    }

    private func configureViewController() {
        title = "Extraction"

        stackView.isHidden = true
    }

    @objc func onCameraImageViewTapped() {
        activityIndicator.startAnimating()

        Task {
            await startExtraction()
        }
    }

    private func startExtraction() async {
        switch requestType {
        case .texts:
            await interactable?.executeGetAllTexts(using: UIImage.add)
        case .face:
            await interactable?.executeGetFace(using: UIImage.add)
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
