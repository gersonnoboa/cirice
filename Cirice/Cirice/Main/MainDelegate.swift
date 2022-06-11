import Foundation
import UIKit

final class MainDelegate: NSObject, UITableViewDelegate {
    var rowSelected: ((Int) -> Void)?

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        rowSelected?(indexPath.row)
    }
}
