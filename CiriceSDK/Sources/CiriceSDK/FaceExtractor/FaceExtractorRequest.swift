import Foundation
import UIKit

public struct FaceExtractorRequest {
    let image: UIImage
    let maximumAllowedFaceCount: Int
    
    public init(image: UIImage, maximumAllowedFaceCount: Int = 1) {
        self.image = image
        self.maximumAllowedFaceCount = maximumAllowedFaceCount
    }
}
