//
//  Created by Fernando Gallo on 29/06/23.
//

import UIKit
import CoreImage

class CapturePhotoHelper {
    static func capturePhotoFrom(imageBuffer: CVImageBuffer, hatImageViews: [UIImageView], flip: Bool) {
        let sourceImage = CIImage(cvPixelBuffer: imageBuffer)
        
        guard let sourceImageResized = resizeCIImage(sourceImage) else {
            return
        }
        
        let image = flip ? UIImage(ciImage: sourceImageResized).withHorizontallyFlippedOrientation() : UIImage(ciImage: sourceImageResized)
        
        if let mergedImage = mergeImages(bottomImage: image, topImageViews: hatImageViews) {
            PHPhotoLibraryHelper.saveImage(mergedImage)
        }
    }
    
    static func mergeImages(bottomImage: UIImage, topImageViews: [UIImageView]) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bottomImage.size, false, 0.0)
        bottomImage.draw(in: CGRect(x: 0, y: 0, width: bottomImage.size.width, height: bottomImage.size.height))
        
        for imageView in topImageViews {
            if let image = imageView.image {
                image.draw(in: CGRect(x: imageView.frame.origin.x,
                                      y: imageView.frame.origin.y,
                                      width: imageView.frame.size.width,
                                      height: imageView.frame.size.height))
            }
        }
        
        let mergedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return mergedImage
    }

    static func resizeCIImage(_ ciImage: CIImage) -> CIImage? {
        let targetSize = UIScreen.main.bounds
        let imageSize = ciImage.extent.size
        
        let widthFactor = targetSize.width / imageSize.width
        let heightFactor = targetSize.height / imageSize.height
        let scaleFactor = max(widthFactor, heightFactor)
        
        let scaledImage = ciImage.transformed(by: CGAffineTransform(scaleX: scaleFactor, y: scaleFactor))
        
        let xInset = (scaledImage.extent.width - targetSize.width) / 2.0
        let yInset = (scaledImage.extent.height - targetSize.height) / 2.0
        
        let croppedImage = scaledImage.cropped(to: scaledImage.extent.insetBy(dx: xInset, dy: yInset))
        return croppedImage
    }
}
