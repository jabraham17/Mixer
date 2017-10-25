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
    
    //different adding modes
    enum Mode: Int {
        case Cue = 0
        case Transition = 1
    }
    //what mode the view is currently in
    var mode: Mode = .Cue {
        didSet {
            switch mode {
            case .Cue:
                //remove the transition view
                addTransitionView?.removeFromSuperview()
                //add the cue view
                self.view.addSubview(addCueView!)
                break
            case .Transition:
                //remove the cue view
                addCueView?.removeFromSuperview()
                //add the transition view
                self.view.addSubview(addTransitionView!)
                break
            }
        }
    }
    
    //subviews
    var cancelButton: UIButton?
    var addButton: UIButton?
    var control: UISegmentedControl?
    var addCueView: UIView?
    var cueNumber: UITextField?
    var cueName: UITextField?
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
        let dividingLine = bounds.height / 8
        let controlArea = CGRect(x: space, y: space, width: bounds.width, height: dividingLine)
        let viewsArea = CGRect(x: space, y: dividingLine, width: bounds.width, height: bounds.height - dividingLine - space)
        
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
        cancelButton = UIButton(frame: CGRect(x: space, y: space, width: controlArea.width / 3, height: (controlArea.height - (2 * space)) / 2))
        cancelButton?.setTitle("Cancel", for: .normal)
        cancelButton?.setTitleColor(.blue, for: .normal)
        cancelButton?.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        
        //button to save edits
        addButton = UIButton(frame: CGRect(x: space + 2 * controlArea.width / 3, y: space, width: controlArea.width / 3, height: (controlArea.height - (2 * space)) / 2))
        addButton?.setTitle("Add", for: .normal)
        addButton?.setTitleColor(.blue, for: .normal)
        addButton?.addTarget(self, action: #selector(addAction), for: .touchUpInside)
        
        //segemented control to switch between cue and transiton mode
        control = UISegmentedControl(frame: CGRect(x: controlArea.width / 10, y: space + (controlArea.height - (2 * space)) / 2, width: 4 * controlArea.width / 5, height: (controlArea.height - (2 * space)) / 2))
        //add first segment, cue
        control?.insertSegment(withTitle: "Cue", at: Mode.Cue.rawValue, animated: false)
        //add second segment, transition
        control?.insertSegment(withTitle: "Transition", at: Mode.Transition.rawValue, animated: false)
        //set selected control to the mode
        control?.selectedSegmentIndex = mode.rawValue
        //add action to control
        control?.addTarget(self, action: #selector(controlChanged), for: .valueChanged)
        
        addCueView = UIView(frame: viewsArea)
        //view to edit cue number
        cueNumber = UITextField(frame: CGRect(x: 0, y: 0, width: addCueView!.frame.width, height: addCueView!.frame.height / 7))
        cueNumber?.font = UIFont.systemFont(ofSize: 20)
        cueNumber?.borderStyle = .roundedRect
        cueNumber?.textAlignment = .left
        //setup number that is the default, the default adds the cue to the end of the list
        cueNumber?.placeholder = "#"
        //setup editing style
        cueNumber?.clearsOnBeginEditing = false
        cueNumber?.clearButtonMode = .never
        cueNumber?.keyboardType = .decimalPad
        
        //view to edit cue name
        cueName = UITextField(frame: CGRect(x: 0, y: addCueView!.frame.height / 7, width: addCueView!.frame.width, height: addCueView!.frame.height / 7))
        cueName?.font = UIFont.systemFont(ofSize: 20)
        cueName?.borderStyle = .roundedRect
        cueName?.textAlignment = .left
        //defualt cue name, append whatever the defualt cue number is
        cueName?.text = "Cue #"
        //setup editing style
        cueName?.clearsOnBeginEditing = false
        cueName?.clearButtonMode = .whileEditing
        
        addCueView?.addSubviews(cueNumber!, cueName!)
        
        addTransitionView = UIView(frame: viewsArea)
        
        //set the mode, this will take care of adding the transitona and cue views
        mode = .Cue
        
        
        //add views to contoller
        self.view.addSubviews(cancelButton!, addButton!, control!)
    }
    
    //load view
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    //when the control changes, adjust which view is showing
    func controlChanged() {
        //set the mode to be the current index of the segemented control
        mode = Mode(rawValue: control!.selectedSegmentIndex)!
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

