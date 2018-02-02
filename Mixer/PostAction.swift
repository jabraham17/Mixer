//
//  PostAction.swift
//  Mixer
//
//  Created by Jacob R. Abraham on 9/27/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import Foundation
import AVFoundation

//action after cue
class PostAction: GenericAction {
    
    //types of actions
    enum ActionType: Int, CustomStringConvertible {
        case None
        case FadeOut
        
        init(name: String) {
            switch name {
            case "Fade Out":
                self = .FadeOut
                break
            default:
                self = .None
                break
            }
        }
        
        
        //string versions of the types
        var description: String {
            let names = ["None", "Fade Out"]
            return names[self.rawValue]
        }
        static let allTypes = [None, FadeOut]
    }
    
    //the time of this action
    var time: TimeInterval
    
    //what the type is for this
    var type: ActionType
    
    //defualt init
    convenience required init() {
        self.init(type: .None)
    }
    //init with a type
    required init(type: ActionType) {
        self.type = type
        self.time = 5.0
    }
    
    //formatted name
    func getFormattedName() -> String {
        return type.description
    }
    func getTypes() -> [ActionType] {
        return ActionType.allTypes
    }
    
    class func initWith(_ string: String) -> PostAction {
        return PostAction(type: ActionType(name: string))
    }
    
    func applyAction(to player: AVAudioPlayer) {
        if type == .None {
            //do nothing
            player.volume = 1.0;
        }
        else if type == .FadeOut {
            print("WE GO")
            //start with 1 volume, go to silent over a time
            player.volume = 1.0;
            player.setVolume(0.0, fadeDuration: time)
        }
    }
}
