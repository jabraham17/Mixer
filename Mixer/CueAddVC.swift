//
//  CueAddVC.swift
//  Mixer
//
//  Created by Jacob R. Abraham on 10/24/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import UIKit

//protocol/delegate that view controller class will acknolege
protocol CueAddDelegate: class {
    //called when popup is closed, will be implemented in view controller acknolwding this protocol/delegate
    func closed(cue: GenericCue)
}


//info view controller, shown as popup
class CueAddVC: UIViewController {
    
    //holds ShowInfoDelegate object, used to call closed for view controller
    weak var delegate: CueAddDelegate?
    
    //the frame to show the view in
    //DO NOT USE THE SUBVIEWS FRAME
    var frame: CGRect? {
        didSet {
            setup()
        }
    }
    
    //subviews
    var cancelButton: UIButton?
    var addButton: UIButton?
    var control: UISegmentedControl?
    var addCueView: UIView?
    var addTransitionView: UIView?
    
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
        let dividingLine = bounds.height / 5
        let buttonArea = CGRect(x: space, y: space, width: bounds.width, height: dividingLine)
        let textArea = CGRect(x: space, y: dividingLine, width: bounds.width, height: bounds.height - dividingLine - space)
        
        /*
             Cue
             optional: number
             name
             script
             pre
             media
             post
         */
        /*
         transiton
         optional: before/after number
         name
         script
         transition
         */
        
        //button to cancel editing
        cancelButton = UIButton(frame: CGRect(x: space, y: space, width: buttonArea.width / 3, height: buttonArea.height))
        cancelButton?.setTitle("Cancel", for: .normal)
        cancelButton?.setTitleColor(.blue, for: .normal)
        
        cancelButton?.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        
        //button to save edits
        addButton = UIButton(frame: CGRect(x: space + 2 * buttonArea.width / 3, y: space, width: buttonArea.width / 3, height: buttonArea.height))
        addButton?.setTitle("Add", for: .normal)
        addButton?.setTitleColor(.blue, for: .normal)
        addButton?.addTarget(self, action: #selector(addAction), for: .touchUpInside)
        
        
        
        //add views to contoller
        self.view.addSubviews(cancelButton!, addButton!)
    }
    
    //load view
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    //on cancel, simply close with the orginal show
    func cancelAction() {
        //dismiss the view
        self.dismiss(animated: true, completion: nil)
    }
    
    //on save, retrieve text from edit view and pass new show
    func addAction() {
        
        //TODO: temp
        //make new cue
        var cue = GenericCue()
        
        //dismiss the view
        self.dismiss(animated: true, completion: {
            //after popup is dismissed, call the delegate
            self.delegate?.closed(cue: cue)
        })
    }
}

