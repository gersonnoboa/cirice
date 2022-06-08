//
//  File.swift
//  
//
//  Created by Gerson Noboa on 08.06.2022.
//

import Foundation

typealias TextImageRecognitionCapableCompletion = ((Result<TextImageRecognitionResponse, Error>) -> Void)

protocol ImageRecognitionCapable {
    func recognizedTexts(
        using request: TextImageRecognitionRequest
    ) async throws -> TextImageRecognitionResponse
}

extension ImageRecognitionCapable where Self == VisionImageRecognition {
    static var live: ImageRecognitionCapable { VisionImageRecognition() }
}
