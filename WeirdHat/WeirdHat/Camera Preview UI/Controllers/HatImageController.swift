//
//  Created by Fernando Gallo on 30/06/23.
//

import UIKit

class HatImageController {
    weak var view: UIView?
    
    var imageViews: [UIImageView]
    let cameraPreview: AVCaptureSessionCameraPreview
    
    init(imageViews: [UIImageView], cameraPreview: AVCaptureSessionCameraPreview) {
        self.imageViews = imageViews
        self.cameraPreview = cameraPreview
    }
    
    func addImagesToView() {
        imageViews.forEach { view?.addSubview($0) }
    }
    
    func removeImagesFromSuperview() {
        imageViews.forEach { $0.removeFromSuperview() }
        imageViews = []
    }
    
    func createHatImageView(withRects rects: [CGRect]) {
        let hatImageViews = rects.map { boundingBox in
            let faceBoundingBoxOnScreen = cameraPreview.previewLayer.layerRectConverted(fromMetadataOutputRect: boundingBox)
            return makeHatImageView(rect: faceBoundingBoxOnScreen)
        }
        imageViews = hatImageViews
    }
    
    func makeHatImageView(rect: CGRect) -> UIImageView {
        let hatSize = rect.size.width
        let hatImageView = UIImageView(frame: CGRect(x: rect.origin.x,
                                                     y: rect.origin.y - hatSize,
                                                     width: hatSize,
                                                     height: hatSize))
        hatImageView.image = UIImage(named: "hat")
        hatImageView.contentMode = UIView.ContentMode.scaleAspectFill
        return hatImageView
    }
}
