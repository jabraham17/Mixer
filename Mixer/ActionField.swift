//
//  ActionField.swift
//  Mixer
//
//  Created by Jacob R. Abraham on 12/29/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import UIKit

class ActionField: UITextField {
    
    //data to be displayed
    var data: [String]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        font = UIFont.systemFont(ofSize: 20)
        textAlignment = .center
        //get rid of cursor
        tintColor = .clear
        
        
        //picker
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        picker.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        inputView = picker
        
        //accesoru view
        let pickerAccessory = UIToolbar()
        pickerAccessory.autoresizingMask = .flexibleHeight
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        doneButton.tintColor = .blue
        //Add the items to the toolbar
        pickerAccessory.items = [flexSpace, doneButton]
        
        inputAccessoryView = pickerAccessory
        
        //set the placeholder
        placeholder = "Action: None"
        
        //blank data
        data = []
    }
    
    //actions
    func done() {
        resignFirstResponder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension ActionField: UIPickerViewDelegate, UIPickerViewDataSource {
    //always one column
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    //length of the data, number of rows
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data!.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data![row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        fatalError("Must be overloaded")
    }
}
