import Foundation
import Vision

class VisionImageRecognition: ImageRecognitionCapable {
    func recognizedTexts(
        using request: TextImageRecognitionRequest
    ) async throws -> TextImageRecognitionResponse {
        return try await withCheckedThrowingContinuation { continuation in
            recognizedTexts(request: request) { result in
                switch result {
                case .success(let response):
                    continuation.resume(returning: response)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    private func recognizedTexts(
        request: TextImageRecognitionRequest,
        completion: @escaping TextImageRecognitionCapableCompletion
    ) {
        guard let cgImage = request.image.cgImage else {
            completion(.failure(CiriceError.unknown))
            return
        }

        let imageRequestHandler = VNImageRequestHandler(cgImage: cgImage)
        let request = VNRecognizeTextRequest { [weak self] request, error in
            self?.recognizeTextHandler(request: request, error: error, completion: completion)
        }

        do {
            try imageRequestHandler.perform([request])
        } catch {
            completion(.failure(CiriceError.unknown))
        }
    }

    private func recognizeTextHandler(request: VNRequest, error: Error?, completion: TextImageRecognitionCapableCompletion) {
        if let error = error {
            completion(.failure(error))
            return
        }

        guard let observations = request.results as? [VNRecognizedTextObservation] else {
            completion(.failure(CiriceError.unknown))
            return
        }

        let recognizedStrings = observations.compactMap { observation in
            return observation.topCandidates(1).first?.string
        }

        let response = TextImageRecognitionResponse(texts: recognizedStrings)

        completion(.success(response))
    }
}

