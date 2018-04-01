//
//  Global.swift
//  Mixer
//
//  Created by Jacob R. Abraham on 9/4/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import UIKit

//contains global constants
class Global {
    
    //the green used by the app for the start buttons
    static let greenStart = #colorLiteral(red: 0.1323567033, green: 0.6418382525, blue: 0.3993836045, alpha: 1)
    //the red used by the app for the back button
    static let redBack = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
    //the blue used by the app for the pause button
    static let bluePause = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
    //the purple used by the app for the redo button
    static let purpleRedo = #colorLiteral(red: 0.720988961, green: 0.1572330074, blue: 0.7200371102, alpha: 1)
    
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
    
    //types of actions
    enum ActionFieldType: Int, CustomStringConvertible {
        case None
        case Pre
        case Post
        case Trans
        
        //string versions of the types
        var description: String {
            let names = ["None", "Pre", "Post", "Trans"]
            return names[self.rawValue]
        }
        static let allTypes = [None, Pre, Post, Trans]
    }
    
    //parsing errors
    enum ParseError: Error {
        case ParseError(message: String)
    }
    
    static var previousOrientation: UIDeviceOrientation?
}
