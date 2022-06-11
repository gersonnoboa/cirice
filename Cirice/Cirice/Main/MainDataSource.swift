import Foundation
import UIKit

final class MainDataSource: NSObject, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Select an option"
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "Main"
        ) as? MainTableViewCell else {
            return UITableViewCell()
        }

        switch indexPath.row {
        case 0:
            cell.title.text = "Extract text"
            cell.longDescription.text = """
            Upload a picture and use Apple's Vision framework to extract \
            all the detected texts.
            """
        case 1:
            cell.title.text = "Extract face"
            cell.longDescription.text = """
            Upload a picture and use Apple's Vision framework to extract \
            a face. If your picture has more than one face, the process \
            will fail.
            """
        default:
            return UITableViewCell()
        }

        return cell
    }


}
