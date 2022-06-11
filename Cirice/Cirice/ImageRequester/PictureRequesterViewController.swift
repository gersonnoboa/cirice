import Foundation
import UIKit
import CiriceSDK

final class PictureRequesterViewController: UIViewController {
    enum PictureRequesterError: Error {
        case invalidImage
    }

    @IBOutlet weak var cameraImageView: UIImageView!
    @IBOutlet weak var resultTextView: UITextView!
    @IBOutlet weak var resultImageView: UIImageView!

    var requestType: RequestType = .texts

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
        addTouchRecognizerToCameraImageView()
    }

    private func configureViewController() {
        title = "Upload your picture"
        navigationItem.prompt = "Touch the camera icon to take a picture"

        prepareInterfaceForResult()
    }

    private func prepareInterfaceForResult() {
        resultTextView.isHidden = requestType == .face
        resultImageView.isHidden = requestType == .texts
    }

    private func addTouchRecognizerToCameraImageView() {
        cameraImageView.isUserInteractionEnabled = true

        let tapRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(onCameraImageViewTapped)
        )
        cameraImageView.addGestureRecognizer(tapRecognizer)
    }

    @objc func onCameraImageViewTapped() {
        Task {
            await startExtraction()
        }
    }

    private func startExtraction() async {
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

        cameraImageView.image = image

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

        cameraImageView.image = image

        do {
            let request = FaceExtractorRequest(image: image)
            return try await CiriceSDK().getFaces(using: request)
        } catch {
            throw error
        }
    }
}
