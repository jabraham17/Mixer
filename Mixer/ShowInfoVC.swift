//
//  ShowInfoVC.swift
//  Mixer
//
//  Created by Jacob R. Abraham on 10/15/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import UIKit

//protocol/delegate that view controller class will acknolege
protocol ShowInfoDelegate: class {
    //called when popup is closed, will be implemented in view controller acknolwding this protocol/delegate
    func closed(show: Show?)
}


//info view controller, shown as popup
class ShowInfoVC: UIViewController {
    
    //holds ShowInfoDelegate object, used to call closed for view controller
    weak var delegate: ShowInfoDelegate?
    
    //orginal show
    var show: Show? {
        didSet {
            //set the text to the current show
            titleEdit?.text = show?.name
            //set the text to the date
            modifiedView?.text = show?.dateLastEdit.description(with: Locale.current)
            //set the text to the date
            createdView?.text = show?.dateCreated.description(with: Locale.current)
        }
    }
    //the frame to show the view in
    //DO NOT USE THE SUBVIEWS FRAME
    var frame: CGRect? {
        didSet {
            setup()
        }
    }
    
    //subviews
    var cancelButton: UIButton?
    var saveButton: UIButton?
    var titleEdit: UITextField?
    var modifiedView: UILabel?
    var createdView: UILabel?
    
    
    //setup view
    func setup() {
        
        //remove all previous subviews
        self.view.removeAllSubviews()
        
        //frame to use here, determine if frame has been inited yet
        let frame = (self.frame ?? CGRect())
        //bounds, decrese frame by small factor so contnt desnt but against edge
        let bounds = CGRect(x: 5, y: 5, width: frame.width - 10, height: frame.height - 10)
        //values to assist in creating framed for view elements
        let dividingLine = bounds.height / 5
        let buttonArea = CGRect(x: 0, y: 0, width: bounds.width, height: dividingLine)
        let textArea = CGRect(x: 0, y: dividingLine, width: bounds.width, height: bounds.height - dividingLine)
        
        //button to cancel editing
        cancelButton = UIButton(frame: CGRect(x: 0, y: 0, width: buttonArea.width / 3, height: buttonArea.height))
        cancelButton?.setTitle("Cancel", for: .normal)
        cancelButton?.setTitleColor(.blue, for: .normal)

        cancelButton?.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        
        //button to save edits
        saveButton = UIButton(frame: CGRect(x: 2 * buttonArea.width / 3, y: 0, width: buttonArea.width / 3, height: buttonArea.height))
        saveButton?.setTitle("Save", for: .normal)
        saveButton?.setTitleColor(.blue, for: .normal)
        saveButton?.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
        
        
        //view to edit title
        titleEdit = UITextField(frame: CGRect(x: 0, y: textArea.minY, width: textArea.width, height: textArea.height / 3))
        //set the text to the current show
        titleEdit?.text = show?.name
        //setup editing style
        titleEdit?.clearsOnBeginEditing = false
        titleEdit?.clearButtonMode = .whileEditing
        
        //view to show date last modified
        modifiedView = UILabel(frame: CGRect(x: 0, y: textArea.minY + textArea.height / 3, width: textArea.width, height: textArea.height / 3))
        //set the text to the date
        modifiedView?.text = "Last Modified On: \(show?.dateLastEdit.description(with: Locale.current) ?? "")"
        
        //view to show date created
        createdView = UILabel(frame: CGRect(x: 0, y: textArea.minY + 2 * textArea.height / 3, width: textArea.width, height: textArea.height / 3))
        //set the text to the date
        createdView?.text = "Last Modified On: \(show?.dateCreated.description(with: Locale.current) ?? "")"
        
        //add views to contoller
        self.view.addSubviews(cancelButton!, saveButton!, titleEdit!, modifiedView!, createdView!)
    }
    
    //load view
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    //on cancel, simply close with the orginal show
    func cancelAction() {
        //dismiss the view
        self.dismiss(animated: true, completion: {
            
            //after popup is dismissed, call the delegate
            self.delegate?.closed(show: self.show)
        })
    }
    //on save, retrieve text from edit view and pass new show
    func saveAction() {
        
        //retrieve the title
        let newTitle = titleEdit?.text
        //reset the show
        show?.name = newTitle!
        //dismiss the view
        self.dismiss(animated: true, completion: {
            //after popup is dismissed, call the delegate
            self.delegate?.closed(show: self.show)
        })
    }
}

extension UIView {
    //abulity to add multiple subviews
    func addSubviews(_ views: UIView...) {
        //get each view in the array
        for view in views {
            //add the view
            addSubview(view)

        }
    }
    //ability to remove all subviews
    func removeAllSubviews() {
        //get each view
        for view in subviews {
            //remove it
            view.removeFromSuperview()
        }
    }
}
