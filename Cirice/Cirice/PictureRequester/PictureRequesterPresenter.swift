import Foundation
import UIKit

/// Interface that describes all picture requester presenter actions.
protocol PictureRequesterPresentable {
    /// Formats the texts to be displayed by the controllable.
    /// - Parameters:
    ///   - texts: Texts to be formatted.
    ///   - originalImage: Image sent to the CiriceSDK for extraction.
    func presentAllTexts(texts: [String], originalImage: UIImage)

    /// Formats the face to be displayed by the controllable.
    /// - Parameters:
    ///   - image: Face to be formatted.
    ///   - originalImage: Image sent to the CiriceSDK for extraction.
    func presentFace(image: UIImage, originalImage: UIImage)

    /// Formats the text to be presented when there is an invalid image error.
    func presentInvalidImageError()

    /// Formats the text to be presented when there is a maximum number of faces error.
    func presentMaximumNumberOfFacesError()

    /// Formats the text to be presented when there is an extraction error.
    /// - Parameter error: Error sent by the CiriceSDK.
    func presentExtractionError(error: Error)

    /// Formats the text to be presented when there are no results to be displayed.
    func presentNoResults()
}

/// Presenter that describes all picture requester actions.
final class PictureRequesterPresenter: PictureRequesterPresentable {
    weak var controllable: PictureRequesterControllable?

    /// Initializes a `PictureRequesterPresenter`.
    /// - Parameter controllable: An instance of `PictureRequesterControllable`.
    init(controllable: PictureRequesterControllable?) {
        self.controllable = controllable
    }

    /// Formats the texts to be displayed by the controllable.
    /// - Parameters:
    ///   - texts: Texts to be formatted.
    ///   - originalImage: Image sent to the CiriceSDK for extraction.
    func presentAllTexts(texts: [String], originalImage: UIImage) {
        controllable?.showAllTexts(
            texts.joined(separator: "\n"),
            originalImage: originalImage
        )
    }

    /// Formats the face to be displayed by the controllable.
    /// - Parameters:
    ///   - image: Face to be formatted.
    ///   - originalImage: Image sent to the CiriceSDK for extraction.
    func presentFace(image: UIImage, originalImage: UIImage) {
        controllable?.showFace(
            image,
            originalImage: originalImage
        )
    }

    /// Formats the text to be presented when there is an invalid image error.
    func presentInvalidImageError() {
        controllable?.showError(message: "Invalid image.")
    }

    /// Formats the text to be presented when there is a maximum number of faces error.
    func presentMaximumNumberOfFacesError() {
        controllable?.showError(message: "Only one face per image is allowed.")
    }

    /// Formats the text to be presented when there is an extraction error.
    /// - Parameter error: Error sent by the CiriceSDK.
    func presentExtractionError(error: Error) {
        controllable?.showError(message: "An error has occurred. " + error.localizedDescription)
    }

    /// Formats the text to be presented when there are no results to be displayed.
    func presentNoResults() {
        controllable?.showError(message: "No faces have been detected in the picture.")
    }
}
