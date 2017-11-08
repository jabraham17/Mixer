//
//  GenericAction.swift
//  Mixer
//
//  Created by Jacob R. Abraham on 9/27/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import Foundation

//all actions conform to this
protocol GenericAction: class {
    
    associatedtype ActionType
    
    var type: ActionType { get set }
    
    //formatted name
    func getFormattedName() -> String
    func getTypes() -> [ActionType]
    
    //inits
    init()
    init(type: ActionType)
}
