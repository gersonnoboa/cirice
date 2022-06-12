import Foundation
import UIKit

/// View controller that shows the main screen.
class MainViewController: UIViewController {
    /// Table view that shows the available options in the app.
    @IBOutlet weak var tableView: UITableView!

    /// Data source to be used for the table view.
    let dataSource = MainDataSource()

    /// Delegate source to be used for the table view.
    let delegate = MainDelegate()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
        configureTableView()
    }

    /// Configure initial view controller state.
    private func configureViewController() {
        title = "Cirice"
    }

    /// Configure initial table view state.
    private func configureTableView() {
        tableView.dataSource = dataSource
        tableView.delegate = delegate

        delegate.onRowSelected = { [weak self] row in
            self?.transitionToPictureRequester()
        }
    }

    /// Transition to the picture requester view controller..
    private func transitionToPictureRequester() {
        performSegue(withIdentifier: "MainToPictureRequester", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        CiriceRouter.preparePictureRequesterViewController(
            segue: segue,
            selectedRow: delegate.selectedRow
        )
    }
}

