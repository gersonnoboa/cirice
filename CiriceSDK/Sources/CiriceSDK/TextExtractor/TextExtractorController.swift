//
//  File.swift
//  
//
//  Created by Gerson Noboa on 08.06.2022.
//

import Foundation
import UIKit

protocol TextExtractorControllable: AnyObject {
    func getAllTexts(using image: UIImage)
}

extension TextExtractorControllable where Self == TextExtractorController {
    static var live: TextExtractorControllable {
        let controller = TextExtractorController()
        let presenter = TextExtractorPresenter(controllable: controller)
        let interactor = TextExtractorInteractor(presentable: presenter)
        controller.interactable = interactor

        return controller
    }
}

class TextExtractorController: TextExtractorControllable {
    var interactable: TextExtractorInteractable?

    func getAllTexts(using image: UIImage) {
        interactable?.getAllTexts(using: image)
    }
}
