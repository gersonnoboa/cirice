import Foundation
import UIKit
import CiriceSDK

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

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
        addTouchRecognizerToCameraImageView()
        onCameraImageViewTapped()
    }

    private func configureViewController() {
        title = "Extraction"

        prepareInterfaceForResult()
    }

    private func prepareInterfaceForResult() {
        resultTextView.isHidden = requestType == .face
        resultImageView.isHidden = requestType == .texts
        stackView.isHidden = true
        activityIndicator.startAnimating()
    }

    private func addTouchRecognizerToCameraImageView() {
        pictureImageView.isUserInteractionEnabled = true

        let tapRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(onCameraImageViewTapped)
        )
        pictureImageView.addGestureRecognizer(tapRecognizer)
    }

    @objc func onCameraImageViewTapped() {
        Task {
            await startExtraction()
        }
    }

    private func startExtraction() async {
        defer {
            activityIndicator.stopAnimating()
        }
        
        do {
            switch requestType {
            case .texts:
                let response = try await getAllTexts()
                resultTextView.text = response.texts.joined(separator: "\n")
            case .face:
                let response = try await getFaces()
                guard let faceImage = response.faceImages.first else { return }

                resultImageView.image = faceImage

            }
            stackView.isHidden = false
        } catch is PictureRequesterError {
            let alert = UIAlertController(
                title: "Error",
                message: "Uploaded image is invalid",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))

            present(alert, animated: true)
        } catch {
            print("Error")
        }
    }

    func getAllTexts() async throws -> TextExtractorResponse {
        guard let image = UIImage(named: "elamisluba") else {
            throw PictureRequesterError.invalidImage
        }

        pictureImageView.image = image

        do {
            let request = TextExtractorRequest(image: image)
            return try await CiriceSDK().getAllTexts(using: request)
        } catch {
            throw error
        }
    }

    func getFaces() async throws -> FaceExtractorResponse {
        guard let image = UIImage(named: "max") else {
            throw PictureRequesterError.invalidImage
        }

        pictureImageView.image = image

        do {
            let request = FaceExtractorRequest(image: image)
            return try await CiriceSDK().getFaces(using: request)
        } catch {
            throw error
        }
    }
}
