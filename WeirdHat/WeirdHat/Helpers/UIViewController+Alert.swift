//
//  Created by Fernando Gallo on 30/06/23.
//

import UIKit

extension UIViewController {
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
