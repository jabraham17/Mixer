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
    var description: String
    var script: String
    
    //default init
    init() {
        self.number = 0
        self.name = ""
        self.description = ""
        self.script = ""
    }
    
    //init
    init(number: Double, name: String, description: String, script: String) {
        self.number = number
        self.name = name
        self.description = description
        self.script = script
    }
    
}
