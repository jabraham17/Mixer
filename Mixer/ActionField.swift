//
//  ActionField.swift
//  Mixer
//
//  Created by Jacob R. Abraham on 11/1/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import UIKit

//protocol/delegate that view controller class will acknolege
protocol ActionFieldDelegate: class {
    //called when popup is closed, will be implemented in view controller acknolwding this protocol/delegate
    func fieldWasTapped(field: ActionField)
}

//field to input and display an action
class ActionField: UIView {
    
    //holds ActionFieldDelegate object, used to call fieldWasTapped for view controller
    weak var delegate: ActionFieldDelegate?
    
    var title: UILabel?
    
    var action: AnyAction<Any>? {
        didSet {
            //on set of the action, set the title to be the action
            title?.text = action?.getFormattedName()
        }
    }
    
    //size of the input view
    var presentationOfInput: UIViewController? {
        //once set, create the picker view
        didSet {
            pickerView = UIPickerView(frame: CGRect(x: 0, y: 3 * presentationOfInput!.view.frame.height / 4, width: presentationOfInput!.view.frame.width, height: presentationOfInput!.view.frame.height / 4))
        }
    }
    
    //the picker view for the field
    var pickerView: UIPickerView? {
        //once set, add deleagte and datasource
        didSet {
            pickerView?.delegate = self
            pickerView?.dataSource = self
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        //setup the title
        title = UILabel(frame: bounds)
        title?.text = "Action"
        //setup format of label
        title?.numberOfLines = 0
        title?.lineBreakMode = .byWordWrapping
        title?.textAlignment = .center
        
        
        
        
        addSubview(title!)
        
        //setup tap gestures
        setupTap()
    }
    
    //setup tap gestures
    func setupTap() {
        //create the tap geture recognizer
        let gesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        title?.isUserInteractionEnabled = true
        //add it to the view
        title?.addGestureRecognizer(gesture)
    }
    //action for tap gesture, simply calls delegate method fieldWasTapped
    func viewTapped() {
        delegate?.fieldWasTapped(field: self)
    }
    
}

extension ActionField: UIPickerViewDelegate, UIPickerViewDataSource {
    //always one column
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    //length of the data, number of rows
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return action!.getTypes().count
    }
}
