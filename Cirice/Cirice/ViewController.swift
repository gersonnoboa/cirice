//
//  ViewController.swift
//  Cirice
//
//  Created by Gerson Noboa on 08.06.2022.
//

import UIKit
import CiriceSDK

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        Task {
            await getAllTexts()
        }
    }

    func getAllTexts() async {
        do {
            let result = try await CiriceSDK().getAllTexts()
            print(result.texts)
        } catch {
            print(error)
        }
    }
}

