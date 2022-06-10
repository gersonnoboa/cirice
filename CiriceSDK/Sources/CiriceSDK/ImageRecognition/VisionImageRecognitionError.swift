import Foundation

public enum VisionImageRecognitionError: Error, Equatable {
    case noImage
    case noResults
    case visionError(String)
}
