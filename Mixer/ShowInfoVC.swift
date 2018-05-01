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
    func closed()
}


//info view controller, shown as popup
class ShowInfoVC: UIViewController {
    
    //holds ShowInfoDelegate object, used to call closed for view controller
    weak var delegate: ShowInfoDelegate?
    
    //orginal show
    var index: Int? {
        didSet {
            //set the text to the current show
            titleEdit?.text = getShow()?.name
            //set the text to the date
            modifiedView?.text = getShow()?.dateLastEdit.description(with: Locale.current)
            //set the text to the date
            createdView?.text = getShow()?.dateCreated.description(with: Locale.current)
        }
    }
    
    func getShow() -> Show? {
        if(index == nil) {
            return nil
        }
        return DataManager.instance.shows[index!]
    }
    
    //the frame to show the view in
    //DO NOT USE THE SUBVIEWS FRAME
    var frame: CGRect? {
        didSet {
            setup()
        }
    }
    
    //formatter for the dates
    var dateFormatter: DateFormatter {
        let format = DateFormatter()
        format.dateStyle = .short
        format.locale = Locale.current
        return format
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
        let space: CGFloat = 5.0
        //bounds, decrese frame by small factor so contnt desnt but against edge
        let bounds = CGRect(x: space, y: space, width: frame.width - (space * 2), height: frame.height - (space * 2))
        //values to assist in creating framed for view elements
        let dividingLine = bounds.height / 5
        let buttonArea = CGRect(x: space, y: space, width: bounds.width, height: dividingLine)
        let textArea = CGRect(x: space, y: dividingLine, width: bounds.width, height: bounds.height - dividingLine - space)
        
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
        
        
        //view to edit title
        titleEdit = UITextField(frame: CGRect(x: space, y: space + textArea.minY, width: textArea.width, height: textArea.height / 3))
        titleEdit?.font = UIFont.systemFont(ofSize: 30)
        titleEdit?.borderStyle = .roundedRect
        titleEdit?.textAlignment = .center
        //set the text to the current show
        titleEdit?.text = getShow()?.name
        //setup editing style
        titleEdit?.clearsOnBeginEditing = false
        titleEdit?.clearButtonMode = .whileEditing
        
        //view to show date last modified
        modifiedView = UILabel(frame: CGRect(x: space, y: space + textArea.minY + textArea.height / 3, width: textArea.width, height: textArea.height / 3))
        //set the text to the date
        modifiedView?.text = "Last Modified On:\n\(dateFormatter.string(from: getShow()!.dateLastEdit))"
        //setup format of label
        modifiedView?.numberOfLines = 0
        modifiedView?.lineBreakMode = .byWordWrapping
        modifiedView?.textAlignment = .center
        
        //view to show date created
        createdView = UILabel(frame: CGRect(x: space, y: space + textArea.minY + 2 * textArea.height / 3, width: textArea.width, height: textArea.height / 3))
        //set the text to the date
        createdView?.text = "Created On:\n\(dateFormatter.string(from: getShow()!.dateCreated))"
        //setup format of label
        createdView?.numberOfLines = 0
        createdView?.lineBreakMode = .byWordWrapping
        createdView?.textAlignment = .center
        
        //add views to contoller
        self.view.addSubviews(cancelButton!, saveButton!, titleEdit!, modifiedView!, createdView!)
    }
    
    //load view
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    //on cancel, simply close with the orginal show
    @objc func cancelAction() {
        //dismiss the view
        self.dismiss(animated: true, completion: nil)
    }
    //on save, retrieve text from edit view and pass new show
    @objc func saveAction() {
        
        //retrieve the title
        let newTitle = titleEdit?.text
        //reset the show
        DataManager.instance.shows[index!].name = newTitle!
        DataManager.instance.save()
        
        //dismiss the view
        self.dismiss(animated: true, completion: {
            //after popup is dismissed, call the delegate
            self.delegate?.closed()
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
