//
//  Created by Fernando Gallo on 30/06/23.
//

import UIKit
import Photos

class PHPhotoLibraryHelper {
    static func saveImage(_ image: UIImage) {
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized, .limited:
                PHPhotoLibrary.shared().performChanges {
                    PHAssetChangeRequest.creationRequestForAsset(from: image)
                }
            default:
                break
            }
        }
    }
}
