import Foundation
import UIKit

final class PictureRequesterViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
    }

    func configureViewController() {
        title = "Upload your picture"
    }
}
