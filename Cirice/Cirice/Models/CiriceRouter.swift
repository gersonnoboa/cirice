import Foundation
import UIKit

/// Implements functionality that extracts the preparation of view controller that are
/// going to be pushed to the stack.
struct CiriceRouter {
    /// Prepares a `PictureRequesterViewController`.
    /// - Parameters:
    ///   - segue: The segue that triggers the push.
    ///   - selectedRow: The selected row that describes which functionality the view
    ///   controller will have.
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
