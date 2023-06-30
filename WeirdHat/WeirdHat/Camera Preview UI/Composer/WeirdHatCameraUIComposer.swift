//
//  Created by Fernando Gallo on 29/06/23.
//

import UIKit

final class WeirdHatCameraUIComposer {
    private init() {}
    
    static func weirdHatCameraComposedWith() -> WeirdHatCameraViewController {
        let capturePhotoHelper = CapturePhotoHelper()
        let cameraPreview = AVCaptureSessionCameraPreview()
        let imageModel = HatImageController(imageViews: [], cameraPreview: cameraPreview)
        
        let weirdHatCameraViewController = makeWeirdHatCameraViewController()
        weirdHatCameraViewController.cameraPreview = cameraPreview
        imageModel.view = weirdHatCameraViewController.view
        
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
        
        weirdHatCameraViewController.onFlipCamera = {
            DispatchQueue.main.async {
                do {
                    try cameraPreview.flipCamera()
                    imageModel.removeImagesFromSuperview()
                } catch {
                    weirdHatCameraViewController.showAlert(with: error)
                }
            }
        }
        
        weirdHatCameraViewController.onTakePicture = {
            guard let imageBuffer = cameraPreview.lastImageBuffer else {
                return
            }
            
            capturePhotoHelper.capturePhotoFrom(imageBuffer: imageBuffer,
                                                hatImageViews: imageModel.imageViews,
                                                flip: cameraPreview.isFlipped)
        }

        return weirdHatCameraViewController
    }
}

extension WeirdHatCameraUIComposer {
    private static func makeWeirdHatCameraViewController() -> WeirdHatCameraViewController {
        let bundle = Bundle(for: WeirdHatCameraViewController.self)
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        let weirdHatCameraViewController = storyboard.instantiateInitialViewController() as! WeirdHatCameraViewController
        return weirdHatCameraViewController
    }
}
