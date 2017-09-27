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
    init(number: Double, name: String, description: String, script: String, media: [Media], preAction: PreAction, postAction: PostAction) {
        self.media = media
        self.preAction = preAction
        self.postAction = postAction
        super.init(number: number, name: name, description: description, script: script)
    }
    
}
