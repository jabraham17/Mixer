//
//  UIButtonBorder.swift
//  Mixer
//
//  Created by Jacob R. Abraham on 9/4/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import UIKit

//make UIButton have border
@IBDesignable class UIButtonBorder: UIButton {
    
    //field for border width of button
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    //field for border color of button
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    //field for corner radius of button
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    //field for image tint color
    @IBInspectable var imageColor: UIColor? {
        get {
            return tintColor
        }
        set {
            //get the image and render it with no color
            let noColorImage = imageView?.image?.withRenderingMode(.alwaysTemplate)
            //set the image
            setImage(noColorImage, for: .normal)
            tintColor = newValue
        }
    }
}


