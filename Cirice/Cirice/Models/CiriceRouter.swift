import Foundation
import UIKit

struct CiriceRouter {
    static func preparePictureRequesterViewController(
        segue: UIStoryboardSegue,
        selectedRow: Int?
    ) {
        guard
            let selectedRow = selectedRow,
            let requestType = RequestType(rawValue: selectedRow),
            let viewController = segue.destination as? PictureRequesterViewController
        else { return }

        let presentable = PictureRequesterPresenter(controllable: viewController)
        let interactable = PictureRequesterInteractor(presentable: presentable)
        viewController.interactable = interactable
        viewController.requestType = requestType
    }
}
