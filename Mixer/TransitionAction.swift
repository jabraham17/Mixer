//
//  TransitionAction.swift
//  Mixer
//
//  Created by Jacob R. Abraham on 9/27/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import Foundation

//action for transition
class TransitionAction: GenericAction {
    
    //types of actions
    enum ActionType: Int, CustomStringConvertible {
        case Wait
        case Pause
        
        init(name: String) {
            switch name {
            case "Wait":
                self = .Wait
                break
            case "Pause":
                self = .Pause
                break
            default:
                self = .Wait
                break
            }
        }
        
        
        //string versions of the types
        var description: String {
            let names = ["Wait", "Pause"]
            return names[self.rawValue]
        }
        static let allTypes = [Wait, Pause]
    }
    
    //what the type is for this
    var type: ActionType
    
    //the time of this action
    var time: TimeInterval
    
    //defualt init
    convenience required init() {
        self.init(type: .Wait)
    }
    //init with a type
    required init(type: ActionType) {
        self.type = type
        self.time = 3.0
    }
    
    //formatted name
    func getFormattedName() -> String {
        return type.description
    }
    func getTypes() -> [ActionType] {
        return ActionType.allTypes
    }

    
    class func initWith(_ string: String) -> TransitionAction {
        return TransitionAction(type: ActionType(name: string))
    }
}
