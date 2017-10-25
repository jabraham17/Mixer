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
    init(number: Double, name: String, script: String, transition: TransitionAction) {
        self.transition = transition
        super.init(number: number, name: name, script: script)
    }
    
}
