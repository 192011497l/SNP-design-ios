//
//  BasicVC.swift
//  ScanAndPay
//
//  Created by SAIL on 04/01/24.
//

import UIKit

class BasicVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        setupTapGesture()
        
        navigationItem.setHidesBackButton(true, animated: false)
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        for textField in self.view.subviews where textField is UITextField {
            textField.resignFirstResponder()
        }
        return true
    }
//    private func setupTapGesture() {
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
//        view.addGestureRecognizer(tapGesture)
//    }
//
//    @objc private func dismissKeyboard() {
//        view.endEditing(true)
//    }
}
extension BasicVC {
    func showAlert(title: String, message: String, okActionHandler: (() -> Void)? = nil, cancelActionHandler: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // OK Action
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            okActionHandler?()
        }
        alertController.addAction(okAction)
        
        // Cancel Action (if provided)
        if let cancelActionHandler = cancelActionHandler {
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                cancelActionHandler()
            }
            alertController.addAction(cancelAction)
        }
        
        present(alertController, animated: true, completion: nil)
    }

}


@IBDesignable class ShadowView: UIView {
    //Shadow
    @IBInspectable var shadowColor: UIColor = UIColor.gray {
        didSet {
            self.updateView()
        }
    }
    @IBInspectable var shadowOpacity: Float = 0.7 {
        didSet {
            self.updateView()
        }
    }
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 1, height: 1) {
        didSet {
            self.updateView()
        }
    }
    @IBInspectable var shadowRadius: CGFloat = 2.0 {
        didSet {
            self.updateView()
        }
    }

    //Apply params
    func updateView() {
        self.layer.shadowColor = self.shadowColor.cgColor
        self.layer.shadowOpacity = self.shadowOpacity
        self.layer.shadowOffset = self.shadowOffset
        self.layer.shadowRadius = self.shadowRadius
    }
}
extension UIView {
    func addShadow(radius: CGFloat = 0) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        layer.shadowRadius = 2
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.cornerRadius = radius
    }
}

@IBDesignable extension UIButton {
    
   
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
}
@IBDesignable extension UILabel {
    
   
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
}
@IBDesignable extension UIView {
    
   
    
    @IBInspectable var cornerRadiusView: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    @IBInspectable var shadowRadiusnew :CGFloat {
        set {
            layer.shadowRadius = newValue
        }
        get {
            return layer.shadowRadius
        }
    }
    
    
    @IBInspectable var borderWidth: CGFloat {
           set {
               layer.borderWidth = newValue
           }
           get {
               return layer.borderWidth
           }
       }
    @IBInspectable var shadowOpacitynew :CGFloat {
        set {
            layer.shadowOpacity = Float(newValue)
        }
        get {
            return CGFloat(layer.shadowOpacity)
        }
    }
    @IBInspectable var shadowOffsetnew : CGSize{
        
        get{
            return layer.shadowOffset
        }set{

            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
            set {
                guard let uiColor = newValue else { return }
                layer.borderColor = uiColor.cgColor
            }
            get {
                guard let color = layer.borderColor else { return nil }
                return UIColor(cgColor: color)
            }
        }
    @IBInspectable var shadowColornew : UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.shadowColor = uiColor.cgColor
        }
        get {
            guard let color = layer.shadowColor else { return nil }
            return UIColor(cgColor: color)
        }
        
    }
}
