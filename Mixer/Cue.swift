//
//  Cue.swift
//  Mixer
//
//  Created by Jacob R. Abraham on 9/27/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import Foundation

//data structure for cue
class Cue: GenericCue {
    
    //entries
    var media: [Media]
    var preAction: PreAction
    var postAction: PostAction
    
    //default init
    override init() {
        self.media = []
        self.preAction = PreAction()
        self.postAction = PostAction()
        super.init()
    }
    
    //init
    init(number: Double, name: String, script: String, media: [Media], preAction: PreAction, postAction: PostAction) {
        self.media = media
        self.preAction = preAction
        self.postAction = postAction
        super.init(number: number, name: name, script: script)
    }
    
    
    //encoding
    private enum CodingKeys: String, CodingKey {
        case media = "mediaID"
        case preAction
        case postAction
        case superClass = "genericCue"
    }
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(media.first?.mediaItem.persistentID, forKey: .media)
        try container.encode(preAction.type.description, forKey: .preAction)
        try container.encode(postAction.type.description, forKey: .postAction)
        //get the super encoder
        let superEncoder = container.superEncoder(forKey: .superClass)
        try super.encode(to: superEncoder)
    }
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        media = try [Media.initWith(values.decode(String.self, forKey: .media))]
        preAction = try PreAction.initWith(values.decode(String.self, forKey: .preAction))
        postAction = try PostAction.initWith(values.decode(String.self, forKey: .postAction))
        //get the super decoder
        let superDecoder = try values.superDecoder(forKey: .superClass)
        try super.init(from: superDecoder)
    }
}
