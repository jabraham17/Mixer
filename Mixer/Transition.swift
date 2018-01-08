//
//  Transition.swift
//  Mixer
//
//  Created by Jacob R. Abraham on 9/27/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import Foundation

//data structure for transitions
class Transition: GenericCue {
    
    //entries
    var transition: TransitionAction
    
    //default init
    override init() {
        self.transition = TransitionAction()
        super.init()
    }
    
    //init
    init(name: String, script: String, transition: TransitionAction) {
        self.transition = transition
        super.init(name: name, script: script)
    }
    
    override func encode() -> String {
        var encoded = super.encode().replacingOccurrences(of: "GenericCue", with: "Transition")
        encoded += ",Transition:<\(transition.type)>"
        return encoded
    }
    required init(decodeWith string: String) throws {
        //first decode the part that belongs here, then pass the string to the super class to parse the rest
        
        //regexs to get the different fields
        let regex = "Transition:<([^<>]*)>"
        let match = regex.r!.findFirst(in: string)
        //check if it matches, if it doesnt, throw an error
        if match == nil {
            throw Global.ParseError.ParseError(message: "The input '\(string)' does not match regex '\(regex)'")
        }
        //if it matches, get all of the variables and load each variable
        transition = TransitionAction(type: .init(name: match!.group(at: 1)!))
        
        
        //call the super
        try super.init(decodeWith: string)
    }
    override var description: String {
        return "\(super.description.replacingOccurrences(of: "Generic", with: "Transition")), with a Transition of '\(transition.getFormattedName())'"
    }
}
