//
//  Created by Fernando Gallo on 29/06/23.
//

import UIKit

class WeirdHatCameraViewController: UIViewController {
    var cameraPreview: AVCaptureSessionCameraPreview!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCameraPreviewLayer()
        
        do {
            try cameraPreview.configureInputAndOutput()
            cameraPreview.start()
        } catch {
            showAlert(with: error)
        }
    }
    
    private func configureCameraPreviewLayer() {
        cameraPreview.previewLayer.videoGravity = .resizeAspectFill
        cameraPreview.previewLayer.frame = view.frame
        view.layer.insertSublayer(cameraPreview.previewLayer, at: 0)
    }
    
    @IBAction private func flipCameraButttonTapped(_ sender: UIButton) {
        do {
            try cameraPreview.flipCamera()
        } catch {
            showAlert(with: error)
        }
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
