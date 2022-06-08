import UIKit

public struct CiriceSDK {
    public private(set) var text = "Hello, World!"

    private let textExtractorControllable: TextExtractorControllable

    public init() {
        textExtractorControllable = .live
    }

    public func getAllTexts(using image: UIImage) {
        textExtractorControllable.getAllTexts(using: image)
    }
}
