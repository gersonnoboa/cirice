import Foundation

public enum ImageRecognitionError: Error, Equatable {
    case noImage
    case noResults
    case maximumExceeded
    case internalError(String)
}
