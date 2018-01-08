//
//  TransitionEditVC.swift
//  Mixer
//
//  Created by Jacob R. Abraham on 1/7/18.
//  Copyright © 2018 Jacob R. Abraham. All rights reserved.
//

import UIKit
import MediaPlayer

//protocol/delegate that view controller class will acknolege
protocol TransitionEditDelegate: class {
    //called when popup is closed, will be implemented in view controller acknolwding this protocol/delegate
    func closed(transIndex: Int, trans: Transition)
    func delete(transIndex: Int)
}

//info view controller, shown as popup
class TransitionEditVC: UIViewController {
    
    //used to call closed for view controller
    weak var delegate: TransitionEditDelegate?
    
    //the frame to show the view in
    //DO NOT USE THE SUBVIEWS FRAME
    var frame: CGRect? {
        didSet {
            setup()
        }
    }
    
    //what cue to show
    var trans: Transition? {
        didSet {
            setup()
        }
    }
    //the index of the cue
    var transIndex: Int? {
        didSet {
            setup()
        }
    }
    
    //subviews
    var cancelButton: UIButton?
    var saveButton: UIButton?
    var deleteButton: UIButton?
    var name: UITextField?
    var script: UITextField?
    var transAction: TransActionField?
    
    //setup view
    func setup() {
        
        //remove all previous subviews
        self.view.removeAllSubviews()
        
        //frame to use here, determine if frame has been inited yet
        let frame = (self.frame ?? CGRect())
        let space: CGFloat = 5.0
        //bounds, decrese frame by small factor so contnt desnt but against edge
        let bounds = CGRect(x: space, y: space, width: frame.width - (space * 2), height: frame.height - (space * 2))
        //values to assist in creating framed for view elements
        let topHeight = bounds.height / 8
        let bottomHeight = topHeight
        let buttonArea = CGRect(x: space, y: space, width: bounds.width, height: topHeight)
        let textArea = CGRect(x: space, y: topHeight, width: bounds.width, height: bounds.height - topHeight - bottomHeight - space)
        let deleteArea = CGRect(x: space, y: space, width: bounds.width, height: bottomHeight)
        
        //button to cancel editing
        cancelButton = UIButton(frame: CGRect(x: space, y: space, width: buttonArea.width / 3, height: buttonArea.height))
        cancelButton?.setTitle("Cancel", for: .normal)
        cancelButton?.setTitleColor(.blue, for: .normal)
        cancelButton?.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        
        //button to save edits
        saveButton = UIButton(frame: CGRect(x: space + 2 * buttonArea.width / 3, y: space, width: buttonArea.width / 3, height: buttonArea.height))
        saveButton?.setTitle("Save", for: .normal)
        saveButton?.setTitleColor(.blue, for: .normal)
        saveButton?.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
        
        //delete button to remove cue
        deleteButton = UIButton(frame: CGRect(x: 0, y: bounds.height - deleteArea.height, width: frame.width, height: deleteArea.height))
        deleteButton?.setTitle("Delete", for: .normal)
        deleteButton?.setTitleColor(.white, for: .normal)
        deleteButton?.backgroundColor = .red
        deleteButton?.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
        
        //height of each element in the cue view
        let elementHeight = textArea.height / 3
        
        //view to edit cue name
        name = UITextField(frame: CGRect(x: space, y: topHeight, width: textArea.width, height: elementHeight))
        name?.font = UIFont.systemFont(ofSize: 20)
        name?.borderStyle = .roundedRect
        name?.textAlignment = .left
        //whatever the cues name is
        name?.text = trans?.name
        //setup editing style
        name?.clearsOnBeginEditing = false
        name?.clearButtonMode = .whileEditing
        name?.returnKeyType = .done
        name?.delegate = self
        
        //view to edit the script for the cue
        script = UITextField(frame: CGRect(x: space, y: topHeight + elementHeight, width: textArea.width, height: elementHeight))
        script?.font = UIFont.systemFont(ofSize: 20)
        script?.borderStyle = .roundedRect
        script?.textAlignment = .left
        //whatever the cues script is, if no script, set the placeholder
        if trans?.script.isEmpty ?? true {
            script?.placeholder = "Location in Script"
        }
        else {
            transAction?.text = trans?.script
        }
        //setup editing style
        script?.clearsOnBeginEditing = false
        script?.clearButtonMode = .whileEditing
        script?.returnKeyType = .done
        script?.delegate = self
        
        //view to edit what pre action to use
        transAction = TransActionField(frame: CGRect(x: space, y: topHeight + (2 * elementHeight), width: textArea.width, height: elementHeight))
        transAction?.action = trans?.transition
        
        //add views to contoller
        self.view.addSubviews(cancelButton!, saveButton!, name!, script!, transAction!, deleteButton!)
    }
    
    //load view
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    //on cancel, simply close with the orginal transition
    @objc func cancelAction() {
        //dismiss the view
        self.dismiss(animated: true, completion: nil)
    }
    //on save, retrieve text from edit view and pass new transition
    @objc func saveAction() {
        
        trans?.name = name!.text!
        trans?.script = script!.text!
        trans?.transition = transAction!.action!
        
        //dismiss the view
        self.dismiss(animated: true, completion: {
            //after popup is dismissed, call the delegate
            self.delegate?.closed(transIndex: self.transIndex!, trans: self.trans!)
        })
    }
    //on delete, tell the view it is supposed to dleete
    @objc func deleteAction() {
        //dismiss the view
        self.dismiss(animated: true, completion: {
            //after popup is dismissed, call the delegate
            self.delegate?.delete(transIndex: self.transIndex!)
        })
    }
}

//text field delegate
extension TransitionEditVC: UITextFieldDelegate {
    //when done button pressed, close text
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

