//
//  File.swift
//  
//
//  Created by Gerson Noboa on 08.06.2022.
//

import Foundation

protocol TextExtractorPresentable {

}

class TextExtractorPresenter: TextExtractorPresentable {
    private weak var controllable: TextExtractorControllable?

    init(controllable: TextExtractorController?) {
        self.controllable = controllable
    }
}
