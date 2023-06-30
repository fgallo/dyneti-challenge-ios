//
//  Created by Fernando Gallo on 29/06/23.
//

import UIKit

class WeirdHatCameraViewController: UIViewController {
    @IBOutlet private(set) var takePictureButton: UIButton!
    @IBOutlet private(set) var flipCameraButton: UIButton!
    @IBOutlet private(set) var infoButton: UIButton!
    
    var cameraPreview: AVCaptureSessionCameraPreview!
    
    private var model = [UIImageView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureButtons()
        configureCameraPreviewLayer()
        binding()
    }
    
    private func binding() {
        do {
            try cameraPreview.configureInputAndOutput()
        } catch {
            showAlert(with: error)
        }
        
        cameraPreview.start()
        
        cameraPreview.onImageCapture = { image in
            VisionFaceRecognition.detectFace(image: image) { result in
                DispatchQueue.main.async {
                    switch result {
                    case let .success(results):
                        self.handleFaceDetectionResults(observedFacesBoundingBoxes: results)
                    case .failure:
                        self.clearHats()
                    }
                }
            }
        }
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
    
    private func handleFaceDetectionResults(observedFacesBoundingBoxes: [CGRect]) {
        clearHats()
        
        let faceHats = observedFacesBoundingBoxes.map { boundingBox in
            let faceBoundingBoxOnScreen = cameraPreview.previewLayer.layerRectConverted(fromMetadataOutputRect: boundingBox)
            return makeHatImageView(rect: faceBoundingBoxOnScreen)
        }
        
        faceHats.forEach { view.addSubview($0) }
        
        model = faceHats
    }
    
    private func clearHats() {
        model.forEach { $0.removeFromSuperview() }
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
                                            hatImageViews: model,
                                            flip: cameraPreview.isFlipped)
    }
}

extension WeirdHatCameraViewController {
    func showAlert(with error: Error) {
        DispatchQueue.main.async {
            let error = error as NSError
            let alert = UIAlertController(title: "Error", message: error.domain, preferredStyle: .alert)
            let action = UIAlertAction(title: "Continue", style: .default)
            alert.addAction(action)
            self.present(alert, animated: true)
        }
    }
}

extension WeirdHatCameraViewController {
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
