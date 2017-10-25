//
//  Strings.swift
//  Mixer
//
//  Created by Jacob R. Abraham on 10/24/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import Foundation

//class to access keys in Strings.plist
class Strings {
    
    //only access strings through on instance
    private static let instance = Strings()
    //only visible func of this class, access instance
    static func getInstance() -> Strings {
        return instance
    }
    
    //plist with all the strings
    private var list: Dictionary<String, String>
    
    //make constructor private so other instances cant be made
    private init() {
        //get the plist
        let path = Bundle.main.path(forResource: "Strings", ofType: "plist")! as String
        list = NSDictionary(contentsOfFile: path) as! Dictionary<String, String>
    }
    
    //get string for the key
    func get(forKey key: String) -> String {
        //get the value of the key
        return list[key]!
    }
}
