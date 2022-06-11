import Foundation

public enum CiriceError: Error, Equatable {
    case textExtractor(VisionImageRecognitionError)
    case faceExtractor(VisionImageRecognitionError)
    case unknown
}
