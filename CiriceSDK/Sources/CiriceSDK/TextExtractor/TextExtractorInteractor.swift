//
//  File.swift
//  
//
//  Created by Gerson Noboa on 08.06.2022.
//

import Foundation
import UIKit
protocol TextExtractorInteractable {
    func getAllTexts(using image: UIImage)
}

class TextExtractorInteractor: TextExtractorInteractable {
    private let presentable: TextExtractorPresentable
    lazy var imageRecognitionCapable: ImageRecognitionCapable = { VisionImageRecognition() }()
    init(presentable: TextExtractorPresentable) {
        self.presentable = presentable
    }

    func getAllTexts(using image: UIImage) {
        let request = TextImageRecognitionRequest(image: image)

        do {
            try imageRecognitionCapable.performTextRecognition(request: request) { result in
                switch result {
                case .success(let response):
                    print(response)
                case .failure(let error):
                    print(error)
                }
            }
        } catch {
            print("Failure")
        }
    }
}
