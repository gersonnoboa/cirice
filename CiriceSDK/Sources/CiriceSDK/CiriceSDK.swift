public struct CiriceSDK {
    public private(set) var text = "Hello, World!"

    private let textExtractorControllable: TextExtractorControllable

    public init() {
        textExtractorControllable = .live
    }

    public func getAllTexts() async throws -> TextExtractorResult {
        return try await textExtractorControllable.getAllTexts()
    }
}
