//
//  Created by Fernando Gallo on 29/06/23.
//

import UIKit

class WeirdHatCameraViewController: UIViewController {
    @IBOutlet private(set) var takePictureButton: UIButton!
    @IBOutlet private(set) var flipCameraButton: UIButton!
    @IBOutlet private(set) var infoButton: UIButton!
    
    var cameraPreview: AVCaptureSessionCameraPreview!
    var imageModel: HatImageController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        binding()
    }
    
    private func binding() {
        do {
            try cameraPreview.configureInputAndOutput()
            cameraPreview.start()
        } catch {
            showAlert(with: error)
        }
    }
    
    @IBAction private func flipCameraButttonTapped(_ sender: UIButton) {
        do {
            try cameraPreview.flipCamera()
        } catch {
            showAlert(with: error)
        }
    }
    
    @IBAction private func takePictureButtonTapped(_ sender: UIButton) {
        guard let imageBuffer = cameraPreview.lastImageBuffer else {
            return
        }
        
        CapturePhotoHelper.capturePhotoFrom(imageBuffer: imageBuffer,
                                            hatImageViews: imageModel.imageViews,
                                            flip: cameraPreview.isFlipped)
    }
}

extension WeirdHatCameraViewController {
    private func configureViews() {
        configureButtons()
        configureCameraPreviewLayer()
    }
    
    private func configureCameraPreviewLayer() {
        cameraPreview.previewLayer.videoGravity = .resizeAspectFill
        view.layer.insertSublayer(cameraPreview.previewLayer, at: 0)
        cameraPreview.previewLayer.frame = view.frame
    }
    
    private func configureButtons() {
        takePictureButton.setImage(symbolFor(name: "circle.inset.filled", size: 80), for: .normal)
        flipCameraButton.setImage(symbolFor(name: "arrow.triangle.2.circlepath.camera", size: 20), for: .normal)
        infoButton.setImage(symbolFor(name: "info.circle", size: 20), for: .normal)
    }
    
    private func symbolFor(name: String, size: CGFloat) -> UIImage? {
        let configuration = UIImage.SymbolConfiguration(pointSize: size, weight: .regular, scale: .large)
        let image = UIImage(systemName: name, withConfiguration: configuration)?
            .withTintColor(.white, renderingMode: .alwaysOriginal)
        return image
    }
}
