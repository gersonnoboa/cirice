//
//  File.swift
//  
//
//  Created by Gerson Noboa on 08.06.2022.
//

import Foundation
protocol TextExtractorInteractable {
    
}

class TextExtractorInteractor: TextExtractorInteractable {
    private let presentable: TextExtractorPresentable

    init(presentable: TextExtractorPresentable) {
        self.presentable = presentable
    }
}
