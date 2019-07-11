import UIKit

extension UIViewController {
  func showAlert(title: String?, message: String?, actions: [UIAlertAction], style: UIAlertController.Style = .alert) {
    let vc = UIAlertController(title: title, message: message, preferredStyle: style)
    if actions.count == 0 {
      vc.addAction(UIAlertAction(title: R.string.localizable.ok(), style: .default, handler: nil))
    } else {
      actions.forEach({ (alertAction) in
        vc.addAction(alertAction)
      })
    }
    self.present(vc, animated: true, completion: nil)
  }
  
  func display(title: String = R.string.localizable.error(), _ error: Error?, remove after: TimeInterval = 3.0, _ completion: (() -> Void)? = nil) {
    var message: String?
    if error is String {
      message = error as? String
    } else {
      message = error?.localizedDescription
    }

    showAlert(title: title, message: message, actions: [])
  }
}

