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
    var media: Media
    var preAction: PreAction
    var postAction: PostAction
    
    //default init
    override init() {
        self.media = Media()
        self.preAction = PreAction()
        self.postAction = PostAction()
        super.init()
    }
    
    //init
    init(number: Double, name: String, script: String, media: Media, preAction: PreAction, postAction: PostAction) {
        self.media = media
        self.preAction = preAction
        self.postAction = postAction
        super.init(number: number, name: name, script: script)
    }
    
    override func encode() -> String {
        var encoded = super.encode().replacingOccurrences(of: "Generic", with: "")
        encoded += ",PreAction:<\(preAction.type)>,MediaID:<\(media.getID())>,PostAction:<\(postAction.type)>"
        return encoded
    }
    required init(decodeWith string: String) throws {
        //first decode the part that belongs here, then pass the string to the super class to parse the rest
        
        //regexs to get the different fields
        let regex = "PreAction:<([^<>]*)>,MediaID:<(\\d*)>,PostAction:<([^<>]*)>"
        let match = regex.r!.findFirst(in: string)
        //check if it matches, if it doesnt, throw an error
        if match == nil {
            throw Global.ParseError.ParseError(message: "The input '\(string)' does not match regex '\(regex)'")
        }
        //if it matches, get all of the variables and load each variable
        preAction = PreAction(type: .init(name: match!.group(at: 1)!))
        media = Media.initWith(match!.group(at: 2)!)
        postAction = PostAction(type: .init(name: match!.group(at: 3)!))
        
        
        
        //call the super
        try super.init(decodeWith: string)
    }
    override var description: String {
        return "\(super.description.replacingOccurrences(of: "Generic ", with: "")), with a Pre Action of '\(preAction.getFormattedName())', with a Post Action of '\(postAction.getFormattedName())', with media named '\(media.getFormattedName())'"
    }
}
