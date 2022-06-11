import Foundation
import UIKit
import CiriceSDK

protocol PictureRequesterInteractable {
    func executeGetAllTexts(using image: UIImage) async
    func executeGetFace(using image: UIImage) async
}

final class PictureRequesterInteractor: PictureRequesterInteractable {
    let presentable: PictureRequesterPresentable

    init(presentable: PictureRequesterPresentable) {
        self.presentable = presentable
    }

    func executeGetAllTexts(using image: UIImage) async {
        guard let elamislubaImage = UIImage(named: "elamisluba") else {
            presentable.presentInvalidImageError()
            return
        }

        do {
            let request = TextExtractorRequest(image: elamislubaImage)
            let response = try await CiriceSDK().getAllTexts(using: request)

            presentable.presentAllTexts(
                texts: response.texts,
                originalImage: elamislubaImage
            )
        } catch {
            presentable.presentExtractionError(error: error)
        }
    }

    func executeGetFace(using image: UIImage) async {
        guard let maxImage = UIImage(named: "max") else {
            presentable.presentInvalidImageError()
            return
        }

        do {
            let request = FaceExtractorRequest(image: maxImage)
            let response = try await CiriceSDK().getFaces(using: request)

            guard let face = response.faceImages.first else {
                presentable.presentGenericError()
                return
            }
            
            presentable.presentFace(
                image: face,
                originalImage: maxImage
            )
        } catch CiriceError.faceExtractor(let error)
            where error == VisionImageRecognitionError.maximumExceeded  {
            presentable.presentMaximumNumberOfFacesError()
        } catch {
            presentable.presentExtractionError(error: error)
        }
    }
}
