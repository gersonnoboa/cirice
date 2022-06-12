import Foundation

public enum CiriceError: Error, Equatable {
    case textExtractor(ImageRecognitionError)
    case faceExtractor(ImageRecognitionError)
    case unknown
}
