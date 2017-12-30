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
    enum TransCodingKeys: String, CodingKey {
        case transition = "transAction"
    }
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: TransCodingKeys.self)
        try container.encode(transition.type.description, forKey: .transition)
    }
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: TransCodingKeys.self)
        transition = try TransitionAction.initWith(values.decode(String.self, forKey: .transition))
        try super.init(from: decoder)
    }
}
