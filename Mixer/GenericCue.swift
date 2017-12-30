//
//  GenericCue.swift
//  Mixer
//
//  Created by Jacob R. Abraham on 9/27/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import Foundation

//abstract class for cues
class GenericCue: Codable {
    
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
    
    //encoding
    enum CodingKeys: String, CodingKey {
        case number = "cueNumber"
        case name
        case script
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(number, forKey: .number)
        try container.encode(name, forKey: .name)
        try container.encode(script, forKey: .script)
    }
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        number = try values.decode(Double.self, forKey: .number)
        name = try values.decode(String.self, forKey: .name)
        script = try values.decode(String.self, forKey: .script)
    }
    
}
