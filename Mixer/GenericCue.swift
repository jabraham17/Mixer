//
//  GenericCue.swift
//  Mixer
//
//  Created by Jacob R. Abraham on 9/27/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import Foundation
import Regex

//abstract class for cues
class GenericCue: Serializable, CustomStringConvertible {    
    
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
    
    func encode() -> String {
        let encoded = "GenericCueName:<\(name)>,Number:<\(number)>,Script:<\(script)>"
        return encoded
    }
    required init(decodeWith string: String) throws {
        //regexs to get the different fields
        let regex = "Name:<([^<>]*)>,Number:<([\\d\\.]*)>,Script:<([^<>]*)>"
        let match = regex.r!.findFirst(in: string)
        //check if it matches, if it doesnt, throw an error
        if match == nil {
            throw Global.ParseError.ParseError(message: "The input '\(string)' does not match regex '\(regex)'")
        }
        //if it matches, get all of the variables and load each variable
        name = match!.group(at: 1)!
        number = Double(match!.group(at: 2)!)!
        script = match!.group(at: 3)!
    }
    var description: String {
        return "Generic Cue named '\(name)', with number '\(number)', with a script location at '\(script)'"
    }
}
