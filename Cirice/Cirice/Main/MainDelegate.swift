import Foundation
import UIKit

/// Delegate to be used for the table view in `MainViewController`.
final class MainDelegate: NSObject, UITableViewDelegate {
    var onRowSelected: ((Int) -> Void)?
    private(set) var selectedRow: Int?

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        onRowSelected?(indexPath.row)

        tableView.deselectRow(at: indexPath, animated: true)
    }
}
