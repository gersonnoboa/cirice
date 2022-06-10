import Foundation

public enum CiriceError: Error, Equatable {
    case textExtractor(VisionImageRecognitionError)
    case unknown
}
