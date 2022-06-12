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
