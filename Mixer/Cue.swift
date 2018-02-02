//
//  Cue.swift
//  Mixer
//
//  Created by Jacob R. Abraham on 9/27/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import Foundation
import AVFoundation

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
    init(name: String, script: String, media: Media, preAction: PreAction, postAction: PostAction) {
        self.media = media
        self.preAction = preAction
        self.postAction = postAction
        super.init(name: name, script: script)
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
    
    //add audio playing to the code
    
    var cuePlayer: AVAudioPlayer?
    var cueTimer: Timer?
    func load() {
        let audioUrl = media.mediaItem?.assetURL
        do  {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            // TODO: error handle if no audio
            cuePlayer = try AVAudioPlayer(contentsOf: audioUrl!)
        }
        catch {
            log.warning("Failure to open url")
        }
    }
    func play() {
        //pre action always fires first
        cuePlayer?.numberOfLoops = 0
        cuePlayer?.prepareToPlay()
        cuePlayer?.play()
        //cuePlayer?.volume = 0.1
        print(cuePlayer?.volume)
        cuePlayer?.setVolume(1, fadeDuration: 10)
        print(cuePlayer?.volume)
        //preAction.applyAction(to: cuePlayer!)
        postActionPlaying = false
        //init a timer
        cueTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }
    //TODO: song cue plays into next cue
    var postActionPlaying: Bool?
    //as cue plays, apply changes as nessacry such as actions
    @objc func update() {
        print(cuePlayer?.volume)
        //check if it is time to play stop action
        if ((cuePlayer?.duration)! - postAction.time) <= (cuePlayer?.currentTime)! && !postActionPlaying! {
            postActionPlaying = true
            postAction.applyAction(to: cuePlayer!)
        }
    }
    func pauseToggle() {
        if(cuePlayer?.isPlaying ?? false)
        {
            cuePlayer?.pause()
        }
        else
        {
            cuePlayer?.play()
        }
    }
    func stop() {
        cuePlayer?.stop()
        cueTimer?.invalidate()
    }
    func unload() {
        cuePlayer = nil
        cueTimer = nil
    }
    //returns a value 0 to 1 that displays the current time
    func computeProgress() -> Float {
        let currentTime = cuePlayer?.currentTime
        let totalTime = cuePlayer?.duration
        return Float(currentTime! / totalTime!)
    }
    
}
