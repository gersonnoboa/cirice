import Foundation
import UIKit

final class MainDelegate: NSObject, UITableViewDelegate {
    var onRowSelected: ((Int) -> Void)?
    private(set) var selectedRow: Int?

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        onRowSelected?(indexPath.row)
    }
}
