//
//  CueAddVC.swift
//  Mixer
//
//  Created by Jacob R. Abraham on 10/24/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import UIKit
import MediaPlayer

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
    
    var addCueView: UIScrollView?
    var cueNumber: UITextField?
    var cueName: UITextField?
    var cueScript: UITextField?
    var cuePreAction: UITextField?
    var cueMedia: MediaField?
    var cuePostAction: UITextField?
    
    var addTransitionView: UIScrollView?
    var transitionNumber: UITextField?
    var transitionName: UITextField?
    var transitionScript: UITextField?
    var transitionAction: UITextField?
    
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
        
        //add views to contoller
        self.view.addSubviews(cancelButton!, addButton!, control!)
        
        //view to hold everything for the cue
        addCueView = UIScrollView(frame: viewsArea)
        addCueView?.showsVerticalScrollIndicator = false
        addCueView?.showsHorizontalScrollIndicator = false
        addCueView?.contentSize = CGSize(width: viewsArea.width, height: viewsArea.height)
        addCueView?.isScrollEnabled = true
        
        //height of each element in the cue view
        let cueElementHeight = addCueView!.frame.height / 6
        
        //view to edit cue number
        cueNumber = UITextField(frame: CGRect(x: 0, y: 0, width: addCueView!.frame.width, height: cueElementHeight))
        cueNumber?.font = UIFont.systemFont(ofSize: 20)
        cueNumber?.borderStyle = .roundedRect
        cueNumber?.textAlignment = .left
        //setup number that is the default, the default adds the cue to the end of the list
        cueNumber?.placeholder = "#"
        //setup editing style
        cueNumber?.clearsOnBeginEditing = false
        cueNumber?.clearButtonMode = .never
        cueNumber?.keyboardType = .decimalPad
        cueNumber?.delegate = self
        
        //view to edit cue name
        cueName = UITextField(frame: CGRect(x: 0, y: cueElementHeight, width: addCueView!.frame.width, height: cueElementHeight))
        cueName?.font = UIFont.systemFont(ofSize: 20)
        cueName?.borderStyle = .roundedRect
        cueName?.textAlignment = .left
        //defualt cue name, append whatever the defualt cue number is
        cueName?.text = "Cue #"
        //setup editing style
        cueName?.clearsOnBeginEditing = false
        cueName?.clearButtonMode = .whileEditing
        cueName?.returnKeyType = .done
        cueName?.delegate = self
        
        //view to edit the script for the cue
        cueScript = UITextField(frame: CGRect(x: 0, y: 2 * cueElementHeight, width: addCueView!.frame.width, height: cueElementHeight))
        cueScript?.font = UIFont.systemFont(ofSize: 20)
        cueScript?.borderStyle = .roundedRect
        cueScript?.textAlignment = .left
        //tell the user what goes in the field
        cueScript?.placeholder = "Location in Script"
        //setup editing style
        cueScript?.clearsOnBeginEditing = false
        cueScript?.clearButtonMode = .whileEditing
        cueScript?.returnKeyType = .done
        cueScript?.delegate = self
        
        //view to edit what pre action to use
        cuePreAction = UITextField(frame: CGRect(x: 0, y: 3 * cueElementHeight, width: addCueView!.frame.width, height: cueElementHeight))
        cuePreAction?.font = UIFont.systemFont(ofSize: 20)
        cuePreAction?.borderStyle = .roundedRect
        cuePreAction?.textAlignment = .left
        //tell the user what goes in the field
        cuePreAction?.placeholder = "Before Cue Starts"
        cuePreAction?.delegate = self
        //setup accesory view to be a picker view not a keyboard
        //TODO: not imprlemenyed
        
        //view to edit what media to use
        cueMedia = MediaField(frame: CGRect(x: 0, y: 4 * cueElementHeight, width: addCueView!.frame.width, height: cueElementHeight))
        cueMedia?.delegate = self
        
        //view to edit what post action to use
        cuePostAction = UITextField(frame: CGRect(x: 0, y: 5 * cueElementHeight, width: addCueView!.frame.width, height: cueElementHeight))
        cuePostAction?.font = UIFont.systemFont(ofSize: 20)
        cuePostAction?.borderStyle = .roundedRect
        cuePostAction?.textAlignment = .left
        //tell the user what goes in the field
        cuePostAction?.placeholder = "After Cue Ends"
        cuePostAction?.delegate = self
        //setup accesory view to be a picker view not a keyboard
        //TODO: not imprlemenyed
        
        addCueView?.addSubviews(cueNumber!, cueName!, cueScript!, cuePreAction!, cueMedia!, cuePostAction!)
        
        //view to hold everything for tarsntion
        addTransitionView = UIScrollView(frame: viewsArea)
        addTransitionView?.showsVerticalScrollIndicator = false
        addTransitionView?.showsHorizontalScrollIndicator = false
        addTransitionView?.contentSize = CGSize(width: viewsArea.width, height: viewsArea.height)
        addTransitionView?.isScrollEnabled = true
        
        //height of each element in the cue view
        let transitionElementHeight = addCueView!.frame.height / 4
        
        //view to edit transition number
        transitionNumber = UITextField(frame: CGRect(x: 0, y: 0, width: addCueView!.frame.width, height: transitionElementHeight))
        transitionNumber?.font = UIFont.systemFont(ofSize: 20)
        transitionNumber?.borderStyle = .roundedRect
        transitionNumber?.textAlignment = .left
        //setup number that is the default, the default adds the transition to the end of the list
        transitionNumber?.placeholder = "#"
        //setup editing style
        transitionNumber?.clearsOnBeginEditing = false
        transitionNumber?.clearButtonMode = .never
        transitionNumber?.keyboardType = .decimalPad
        transitionNumber?.delegate = self
        
        //view to edit transition name
        transitionName = UITextField(frame: CGRect(x: 0, y: transitionElementHeight, width: addCueView!.frame.width, height: transitionElementHeight))
        transitionName?.font = UIFont.systemFont(ofSize: 20)
        transitionName?.borderStyle = .roundedRect
        transitionName?.textAlignment = .left
        //defualt cue name, append whatever the defualt cue number is
        transitionName?.text = "Cue #"
        //setup editing style
        transitionName?.clearsOnBeginEditing = false
        transitionName?.clearButtonMode = .whileEditing
        transitionName?.returnKeyType = .done
        transitionName?.delegate = self
        
        //view to edit the script for the transition
        transitionScript = UITextField(frame: CGRect(x: 0, y: 2 * transitionElementHeight, width: addCueView!.frame.width, height: transitionElementHeight))
        transitionScript?.font = UIFont.systemFont(ofSize: 20)
        transitionScript?.borderStyle = .roundedRect
        transitionScript?.textAlignment = .left
        //tell the user what goes in the field
        transitionScript?.placeholder = "Location in Script"
        //setup editing style
        transitionScript?.clearsOnBeginEditing = false
        transitionScript?.clearButtonMode = .whileEditing
        transitionScript?.returnKeyType = .done
        transitionScript?.delegate = self
        
        //view to edit what transition to use
        transitionAction = UITextField(frame: CGRect(x: 0, y: 3 * transitionElementHeight, width: addCueView!.frame.width, height: transitionElementHeight))
        transitionAction?.font = UIFont.systemFont(ofSize: 20)
        transitionAction?.borderStyle = .roundedRect
        transitionAction?.textAlignment = .left
        //tell the user what goes in the field
        transitionAction?.placeholder = "Transition"
        transitionAction?.delegate = self
        //setup accesory view to be a picker view not a keyboard
        //TODO: not imprlemenyed
        
        addTransitionView?.addSubviews(transitionNumber!, transitionName!, transitionScript!, transitionAction!)
        
        //set the mode, this will take care of adding the transitona and cue views
        mode = .Cue
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

//text field delegate
extension CueAddVC: MediaFieldDelegate {
    //when view is tapped, pick the media
    func fieldWasTapped() {
        pickMedia()
    }
}


//text field delegate
extension CueAddVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //on return, close text field
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //while editing, set the content inset
        switch(mode) {
        case .Cue:
            //if the cue view is open
            //TODO: only moves by a number, not by keyboard height
            addCueView?.contentInset.bottom = 200
            break
        case .Transition:
            //if the trandition view is open
            //TODO: only moves by a number, not by keyboard height
            addTransitionView?.contentInset.bottom = 200
            break
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        //when done, reset content inset
        switch(mode) {
        case .Cue:
            //if the cue view is open
            addCueView?.contentInset.bottom = 0
            break
        case .Transition:
            //if the trandition view is open
            addTransitionView?.contentInset.bottom = 0
            break
        }
    }
}

//Media picker delegate
extension CueAddVC: MPMediaPickerControllerDelegate {
    
    //fucntion called when user taos on media field
    func pickMedia() {
        //make the picker
        let mediaPicker = MPMediaPickerController(mediaTypes: .anyAudio)
        //only one item at a time
        mediaPicker.allowsPickingMultipleItems = false
        //set the popover to the field
        mediaPicker.popoverPresentationController?.sourceView = self.view
        //add the delagte methods
        mediaPicker.delegate = self
        self.present(mediaPicker, animated: true, completion: nil)
    }
    
    //on select media item, add the information of the media item to the media field
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        
        //make a media obect
        let media = Media(item: mediaItemCollection.items.first!)
        //add to the media field
        cueMedia?.media = media
        
        //dismiss the medie player
        mediaPicker.dismiss(animated: true, completion: nil)
    }
    //if cancel, just dismiss
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        mediaPicker.dismiss(animated: true, completion: nil)
    }
}

