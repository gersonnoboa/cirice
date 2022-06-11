import Foundation
import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    let dataSource = MainDataSource()
    let delegate = MainDelegate()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
        configureTableView()
    }

    private func configureViewController() {
        title = "Cirice"
        navigationController?.navigationBar.prefersLargeTitles = false
    }

    private func configureTableView() {
        tableView.dataSource = dataSource
        tableView.delegate = delegate

        delegate.onRowSelected = { [weak self] row in
            self?.transitionToPictureRequester()
        }
    }

    private func transitionToPictureRequester() {
        performSegue(withIdentifier: "MainToPictureRequester", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let selectedRow = delegate.selectedRow,
            let requestType = RequestType(rawValue: selectedRow)
        else { return }

        let destination = segue.destination as? PictureRequesterViewController
        destination?.requestType = requestType
    }
}

