import Foundation
import UIKit

protocol PictureRequesterPresentable {
    func presentAllTexts(texts: [String], originalImage: UIImage)
    func presentFace(image: UIImage, originalImage: UIImage)
    func presentInvalidImageError()
    func presentMaximumNumberOfFacesError()
    func presentGenericError()
    func presentExtractionError(error: Error)
}

final class PictureRequesterPresenter: PictureRequesterPresentable {
    weak var controllable: PictureRequesterControllable?

    init(controllable: PictureRequesterControllable?) {
        self.controllable = controllable
    }

    func presentAllTexts(texts: [String], originalImage: UIImage) {
        controllable?.showAllTexts(
            texts.joined(separator: "\n"),
            originalImage: originalImage
        )
    }

    func presentFace(image: UIImage, originalImage: UIImage) {
        controllable?.showFace(
            image,
            originalImage: originalImage
        )
    }

    func presentInvalidImageError() {
        controllable?.showError(message: "Invalid image")
    }

    func presentGenericError() {
        controllable?.showError(message: "An error has occurred. Please try again.")
    }

    func presentExtractionError(error: Error) {
        controllable?.showError(message: "An error has occurred. " + error.localizedDescription)
    }

    func presentMaximumNumberOfFacesError() {
        controllable?.showError(message: "Only one face per image is allowed.")
    }
}
