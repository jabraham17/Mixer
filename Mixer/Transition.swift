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
    
    
    //encoding
    private enum CodingKeys: String, CodingKey {
        case transition = "transAction"
        case superClass = "genericCue"
    }
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(transition.type.description, forKey: .transition)
        //get the super encoder
        let superEncoder = container.superEncoder(forKey: .superClass)
        try super.encode(to: superEncoder)
    }
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        transition = try TransitionAction.initWith(values.decode(String.self, forKey: .transition))
        //get the super decoder
        let superDecoder = try values.superDecoder(forKey: .superClass)
        try super.init(from: superDecoder)
    }
}
