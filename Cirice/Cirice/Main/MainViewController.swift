import UIKit
import CiriceSDK

class MainViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    let dataSource = MainDataSource()
    let delegate = MainDelegate()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
        configureTableView()
    }

    private func configureTableView() {
        tableView.dataSource = dataSource
        tableView.delegate = delegate

        delegate.rowSelected = { [weak self] _ in
            self?.transitionToPictureRequester()
        }
    }

    private func transitionToPictureRequester() {
        performSegue(withIdentifier: "MainToPictureRequester", sender: nil)
    }

    private func configureViewController() {
        title = "Cirice"
        navigationController?.navigationBar.prefersLargeTitles = false
    }

    func getAllTexts() async {
        guard let image = UIImage(named: "elamisluba") else { return }

        do {
            let request = TextExtractorRequest(image: image)
            let response = try await CiriceSDK().getAllTexts(using: request)
            print(response.texts)
        } catch {
            print(error)
        }
    }
    
    func getFaces() async {
        guard let image = UIImage(named: "family") else { return }

        do {
            let request = FaceExtractorRequest(image: image)
            let response = try await CiriceSDK().getFaces(using: request)

            DispatchQueue.main.async { [weak self] in
                for (idx, image) in response.faceImages.enumerated() {
                    let imageView = UIImageView(frame: CGRect(x: 100, y: (idx*100) + 100, width: 100, height: 100))
                    imageView.image = image
                    self?.view.addSubview(imageView)
                }
            }
        } catch {
            print(error)
        }
    }
}

