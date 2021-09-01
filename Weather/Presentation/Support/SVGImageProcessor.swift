import SVGKit
import Kingfisher

/// Image processor for SVG support in Kingfisher
struct SVGImageProcessor: ImageProcessor {
    public var identifier: String = "weather"
    public func process(item: ImageProcessItem, options: KingfisherParsedOptionsInfo) -> KFCrossPlatformImage? {
        switch item {
        case .image(let image):
            return image
        case .data(let data):
            let SVGImage = SVGKImage(data: data)
            return SVGImage?.uiImage
        }
    }
}
