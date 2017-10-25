//
//  GenericCue.swift
//  Mixer
//
//  Created by Jacob R. Abraham on 9/27/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import Foundation

//abstract class for cues
class GenericCue {
    
    //entries
    var number: Double
    var name: String
    var script: String
    
    //default init
    init() {
        self.number = 0
        self.name = ""
        self.script = ""
    }
    
    //init
    init(number: Double, name: String, script: String) {
        self.number = number
        self.name = name
        self.script = script
    }
    
}
