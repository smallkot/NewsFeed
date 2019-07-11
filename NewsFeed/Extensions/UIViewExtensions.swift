import UIKit

extension UIView {
  
  @IBInspectable var borderColor: UIColor? {
    get {
      if let currentColor = layer.borderColor {
        return UIColor(cgColor: currentColor)
      } else {
        return nil
      }
    }
    set {
      layer.borderColor = newValue?.cgColor
    }
  }
  
  @IBInspectable var cornerRadius: CGFloat {
    get {
      return self.layer.cornerRadius
    }
    set {
      self.layer.cornerRadius = newValue
    }
  }
  
  @IBInspectable var borderWidth: CGFloat {
    get {
      return self.layer.borderWidth
    }
    set {
      self.layer.borderWidth = newValue
    }
  }
  
  func setHiddenStateRecursively(isHidden: Bool) {
    while self.isHidden != isHidden {
      self.isHidden = isHidden
    }
  }
  
  func setHiddenStateConditionally(isHidden: Bool) {
    if self.isHidden != isHidden {
      self.isHidden = isHidden
    }
  }
  
  func asUIImage() -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0)
    guard let context = UIGraphicsGetCurrentContext() else { return nil }
    layer.render(in: context)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
  }
  
  static func responder(in view: UIView) -> UIView? {
    guard view.isFirstResponder == false else {
      return view
    }
    for subview in view.subviews {
      if let responder = UIView.responder(in: subview) {
        return responder
      }
    }
    return nil
  }
  
  func containsAsSubview(_ view: UIView) -> Bool {
    for subview in subviews {
      if subview === view {
        return true
      }
      if subview.containsAsSubview(view) {
        return true
      }
    }
    return false
  }
  
  func translateFrame(of view: UIView) -> CGRect {
    guard self !== view else {
      return frame
    }
    var initialFrame = view.frame
    var superview: UIView? = view.superview
    while let _superview = superview, _superview !== self {
      initialFrame.origin.x += _superview.frame.origin.x
      initialFrame.origin.y += _superview.frame.origin.y
      superview = _superview.superview
    }
    return initialFrame
  }
  
  func removeAllConstraints() {
    
  }
}

extension UIView {
  
  func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
    let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
    let mask = CAShapeLayer()
    mask.path = path.cgPath
    self.layer.mask = mask
  }
  
}
