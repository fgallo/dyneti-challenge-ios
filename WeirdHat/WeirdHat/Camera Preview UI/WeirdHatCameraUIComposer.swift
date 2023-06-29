//
//  Created by Fernando Gallo on 29/06/23.
//

import UIKit

final class WeirdHatCameraUIComposer {
    private init() {}
    
    static func weirdHatCameraComposedWith() -> WeirdHatCameraViewController {
        let cameraPreview = AVCaptureSessionCameraPreview()
        
        let weirdHatCameraViewController = makeWeirdHatCameraViewController()
        weirdHatCameraViewController.cameraPreview = cameraPreview
        return weirdHatCameraViewController
    }
    
    private static func makeWeirdHatCameraViewController() -> WeirdHatCameraViewController {
        let bundle = Bundle(for: WeirdHatCameraViewController.self)
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        let weirdHatCameraViewController = storyboard.instantiateInitialViewController() as! WeirdHatCameraViewController
        return weirdHatCameraViewController
    }
}
