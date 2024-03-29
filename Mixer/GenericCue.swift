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
class GenericCue: NSObject, Serializable {
    
    //entries
    var name: String
    var script: String
    
    //default init
    override init() {
        self.name = ""
        self.script = "No Script"
    }
    
    //init
    init(name: String, script: String) {
        self.name = name
        if script == "" {
            self.script = "No Script"
        }
        else {
            self.script = script
        }
    }
    
    func encode() -> String {
        let encoded = "GenericCueName:<\(name)>,Script:<\(script)>"
        return encoded
    }
    required init(decodeWith string: String) throws {
        //regexs to get the different fields
        let regex = "Name:<([^<>]*)>,Script:<([^<>]*)>"
        let match = regex.r!.findFirst(in: string)
        //check if it matches, if it doesnt, throw an error
        if match == nil {
            throw Global.ParseError.ParseError(message: "The input '\(string)' does not match regex '\(regex)'")
        }
        //if it matches, get all of the variables and load each variable
        name = match!.group(at: 1)!
        script = match!.group(at: 2)!
    }
    override var description: String {
        return "Generic Cue named '\(name)' with a script location at '\(script)'"
    }
}
