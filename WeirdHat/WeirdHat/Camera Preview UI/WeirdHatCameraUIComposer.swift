//
//  Created by Fernando Gallo on 29/06/23.
//

import UIKit

final class WeirdHatCameraUIComposer {
    private init() {}
    
    static func weirdHatCameraComposedWith() -> WeirdHatCameraViewController {
        let cameraPreview = AVCaptureSessionCameraPreview()
        let imageModel = HatImageController(imageViews: [], cameraPreview: cameraPreview)
        
        cameraPreview.onImageCapture = { image in
            VisionFaceRecognition.detectFace(image: image) { result in
                DispatchQueue.main.async {
                    switch result {
                    case let .success(results):
                        imageModel.removeImagesFromSuperview()
                        imageModel.createHatImageView(withRects: results)
                        imageModel.addImagesToView()
                    case .failure:
                        imageModel.removeImagesFromSuperview()
                    }
                }
            }
        }
        
        let weirdHatCameraViewController = makeWeirdHatCameraViewController()
        weirdHatCameraViewController.cameraPreview = cameraPreview
        weirdHatCameraViewController.imageModel = imageModel
        imageModel.view = weirdHatCameraViewController.view
        return weirdHatCameraViewController
    }
    
    private static func makeWeirdHatCameraViewController() -> WeirdHatCameraViewController {
        let bundle = Bundle(for: WeirdHatCameraViewController.self)
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        let weirdHatCameraViewController = storyboard.instantiateInitialViewController() as! WeirdHatCameraViewController
        return weirdHatCameraViewController
    }
}
