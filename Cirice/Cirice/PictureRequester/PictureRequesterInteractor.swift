import Foundation
import UIKit
import CiriceSDK

/// Interface that describes all picture requester interactor actions.
protocol PictureRequesterInteractable {
    /// Calls the CiriceSDK to extract all texts from the image.
    /// - Parameter image: Image sent to the CiriceSDK for extraction.
    func executeGetAllTexts(using image: UIImage) async

    /// Calls the CiriceSDK to extract a face from the image.
    /// - Parameter image: Image sent to the CiriceSDK for extraction.
    func executeGetFace(using image: UIImage) async
}

/// Interactor that describes all picture requester actions.
final class PictureRequesterInteractor: PictureRequesterInteractable {
    let presentable: PictureRequesterPresentable

    /// Initializes a `PictureRequesterInteractor`.
    /// - Parameter presentable: An instance of `PictureRequesterPresentable`.
    init(presentable: PictureRequesterPresentable) {
        self.presentable = presentable
    }

    /// Calls the CiriceSDK to extract all texts from the image.
    /// - Parameter image: Image sent to the CiriceSDK for extraction.
    func executeGetAllTexts(using image: UIImage) async {
        do {
            let request = TextExtractorRequest(image: image)
            let response = try await CiriceSDK().getAllTexts(using: request)

            presentable.presentAllTexts(
                texts: response.texts,
                originalImage: image
            )
        } catch {
            presentable.presentExtractionError(error: error)
        }
    }

    /// Calls the CiriceSDK to extract a face from the image.
    /// - Parameter image: Image sent to the CiriceSDK for extraction.
    func executeGetFace(using image: UIImage) async {
        do {
            let request = FaceExtractorRequest(image: image)
            let response = try await CiriceSDK().getFaces(using: request)

            guard let face = response.faceImages.first else {
                presentable.presentNoResults()
                return
            }
            
            presentable.presentFace(
                image: face,
                originalImage: image
            )
        } catch CiriceError.faceExtractor(let error)
            where error == ImageRecognitionError.maximumExceeded  {
            presentable.presentMaximumNumberOfFacesError()
        } catch {
            presentable.presentExtractionError(error: error)
        }
    }
}
