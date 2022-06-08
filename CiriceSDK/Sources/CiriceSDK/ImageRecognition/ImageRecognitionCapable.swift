//
//  File.swift
//  
//
//  Created by Gerson Noboa on 08.06.2022.
//

import Foundation
import Vision

typealias TextImageRecognitionCapableCompletion = ((Result<TextImageRecognitionResponse, Error>) -> Void)

protocol ImageRecognitionCapable {
    func performTextRecognition(
        request: TextImageRecognitionRequest,
        completion: TextImageRecognitionCapableCompletion?
    ) throws
}

class VisionImageRecognition: ImageRecognitionCapable {
    private var completion: TextImageRecognitionCapableCompletion?

    func performTextRecognition(
        request: TextImageRecognitionRequest,
        completion: TextImageRecognitionCapableCompletion?
    ) throws {
        guard let cgImage = request.image.cgImage else {
            throw CiriceError.unknown
        }

        self.completion = completion

        let imageRequestHandler = VNImageRequestHandler(cgImage: cgImage)
        let request = VNRecognizeTextRequest(completionHandler: recognizeTextHandler)

        do {
            try imageRequestHandler.perform([request])
        } catch {
            print("Failure to perform request")
        }
    }

    func recognizeTextHandler(request: VNRequest, error: Error?) {
        if let error = error {
            completion?(.failure(error))
            return
        }

        guard let observations = request.results as? [VNRecognizedTextObservation] else {
            completion?(.failure(CiriceError.unknown))
            return
        }

        let recognizedStrings = observations.compactMap { observation in
            return observation.topCandidates(1).first?.string
        }

        let response = TextImageRecognitionResponse(strings: recognizedStrings)

        completion?(.success(response))
    }
}
