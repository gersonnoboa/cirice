import Foundation

public enum VisionImageRecognitionError: Error, Equatable {
    case noImage
    case noResults
    case maximumExceeded
    case visionError(String)
}
