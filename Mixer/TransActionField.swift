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
            //also set the selected action
            (inputView as! UIPickerView).selectRow(data?.index(of: action!.type.description) ?? 0, inComponent: 0, animated: false)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //action
        action = TransitionAction(type: .Wait)
        
        //set the text
        text = "Transition Action: \(action!.getFormattedName())"
        
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
        action?.type = TransitionAction.ActionType(name: selectedStr)
        //on set of the action, set the title to be the action
        self.text = "Transition Action: \(action!.getFormattedName())"
    }
}
