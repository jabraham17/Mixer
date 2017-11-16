//
//  AnyAction.swift
//  Mixer
//
//  Created by Jacob R. Abraham on 11/4/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import Foundation

//class to provide type erasurer for the GenericAction protocols
class AnyAction<AnyActionType>: GenericAction {
    
    //get the type from the protovl
    typealias ActionType = AnyActionType
    
    //init with the action
    init<Action: GenericAction>(action: Action) where Action.ActionType == AnyActionType {
        //set all of the actions fucntions to the functions here
        _getFormattedName = action.getFormattedName
        _getTypes = action.getTypes
        
        type = action.type
    }
    
    private let _getFormattedName: () -> String
    private let _getTypes: () -> [ActionType]
    
    //what type this is
    var type: ActionType
    
    func getTypes() -> [ActionType] {
        return _getTypes()
    }
    
    func getFormattedName() -> String {
        //call the inited actions func
        return _getFormattedName()
    }
    
    //do nothing here
    required init(type: ActionType) {
        fatalError("Cannot create AnyAction in this way")
    }
    //do nothing here
    required init() {
        fatalError("Cannot create AnyAction in this way")
    }
    
}
