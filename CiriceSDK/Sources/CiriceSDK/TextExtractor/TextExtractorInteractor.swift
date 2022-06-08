//
//  File.swift
//  
//
//  Created by Gerson Noboa on 08.06.2022.
//

import Foundation
import UIKit

protocol TextExtractorInteractable {
    func getTexts(using request: TextExtractorRequest) async throws -> TextExtractorResponse
}

extension TextExtractorInteractable where Self == TextExtractorInteractor {
    static var live: TextExtractorInteractable { TextExtractorInteractor() }
}

class TextExtractorInteractor: TextExtractorInteractable {
    private let imageRecognitionCapable: ImageRecognitionCapable

    init(imageRecognitionCapable: ImageRecognitionCapable = .live) {
        self.imageRecognitionCapable = imageRecognitionCapable
    }

    func getTexts(using textExtractorRequest: TextExtractorRequest) async throws -> TextExtractorResponse {
        let imageRecognitionRequest = TextImageRecognitionRequest(image: textExtractorRequest.image)
        let imageRecognitionResponse = try await imageRecognitionCapable.recognizedTexts(using: imageRecognitionRequest)
        let textExtractorResponse = TextExtractorResponse(texts: imageRecognitionResponse.texts)

        return textExtractorResponse

    }
}
