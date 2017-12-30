//
//  PreAction.swift
//  Mixer
//
//  Created by Jacob R. Abraham on 9/27/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import Foundation

//action before cue
class PreAction: GenericAction {
    
    //types of actions
    enum ActionType: Int, CustomStringConvertible {
        case None
        case FadeIn
        
        init(name: String) {
            switch name {
            case "Fade In":
                self = .FadeIn
                break
            default:
                self = .None
                break
            }
        }
        
        //string versions of the types
        var description: String {
            let names = ["None", "Fade In"]
            return names[self.rawValue]
        }
        static let allTypes = [None, FadeIn]
    }
    
    
    //what the type is for this
    var type: ActionType
    
    //defualt init
    convenience required init() {
        self.init(type: .None)
    }
    //init with a type
    required init(type: ActionType) {
        self.type = type
    }
    
    //formatted name
    func getFormattedName() -> String {
        return type.description
    }
    func getTypes() -> [ActionType] {
        return ActionType.allTypes
    }
    
    class func initWith(_ string: String) -> PreAction {
        return PreAction(type: ActionType(name: string))
    }
}
