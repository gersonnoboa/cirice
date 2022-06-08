import UIKit
import CiriceSDK

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        Task {
            await getAllTexts()
        }
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
}

