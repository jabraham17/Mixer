//
//  MediaField.swift
//  Mixer
//
//  Created by Jacob R. Abraham on 10/26/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import UIKit

//protocol/delegate that view controller class will acknolege
protocol MediaFieldDelegate: class {
    //called when popup is closed, will be implemented in view controller acknolwding this protocol/delegate
    func fieldWasTapped()
}

//field to input and display a media item
class MediaField: UIView {
    
    //holds MediaFieldDelegate object, used to call fieldWasTapped for view controller
    weak var delegate: MediaFieldDelegate?
    
    var title: UILabel?
    
    var media: Media? {
        didSet {
            //on set of the media, set the title to be the media
            title?.text = media?.getFormattedName()
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
        title = UILabel(frame: bounds)
        title?.text = "Media"
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
        delegate?.fieldWasTapped()
    }
    
}
