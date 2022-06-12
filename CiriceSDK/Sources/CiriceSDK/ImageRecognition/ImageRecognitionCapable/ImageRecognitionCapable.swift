import Foundation

/// The protocol that wraps around the framework that does the work of extracting
/// text and faces from images.
protocol ImageRecognitionCapable {
    /// Gets all the texts recognized from an image.
    /// - Parameter request: The request to be used for the extraction.
    /// - Returns: The response that encapsulates the result provided by
    /// the image recognition framework.
    /// - Throws: `ImageRecognitionError`
    func recognizedTexts(
        using request: TextImageRecognitionRequest
    ) async throws -> TextImageRecognitionResponse

    /// Gets the faces recognized from an image.
    /// - Parameter request: The request to be used for the extraction.
    /// - Returns: The response that encapsulates the result provided by
    /// the image recognition framework.
    /// - Throws: `ImageRecognitionError`
    func recognizedFaces(
        using request: FaceImageRecognitionRequest
    ) async throws -> FaceImageRecognitionResponse
}

extension ImageRecognitionCapable where Self == VisionImageRecognition {
    /// The image recognition implementation that holds the production functionality. In this case,
    /// an instance of `VisionImageRecognition`, which wraps around the Vision framework.
    static var live: ImageRecognitionCapable { VisionImageRecognition() }
}
