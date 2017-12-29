//
//  TransActionField.swift
//  Mixer
//
//  Created by Jacob R. Abraham on 11/1/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import UIKit

class TransActionField: ActionField {
    
    //action for the view
    var action: TransitionAction? {
        didSet {
            //on set of the action, set the title to be the action
            self.text = "Transition Action: \(action!.getFormattedName())"
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //action
        action = TransitionAction(type: .None)
        
        //set the placeholder
        placeholder = "Transition Action: None"
        
        //blank data
        data = action?.getTypes().map({
            $0.description
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension TransActionField {
    
    override func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //interpolate what was selected and set it as the action
        let selectedStr = data![row]
        switch(selectedStr) {
        case "None":
            action!.type = .None
            break
        case "Wait":
            action!.type = .Wait
            break
        case "Pause":
            action!.type = .Pause
            break
        default:
            break
        }
        //on set of the action, set the title to be the action
        self.text = "Transition Action: \(action!.getFormattedName())"
    }
}
