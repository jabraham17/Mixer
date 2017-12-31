//
//  CustomUINavigationTitle.swift
//  Mixer
//
//  Created by Jacob R. Abraham on 10/3/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import UIKit

//protocol/delegate that view controller class will acknolege
protocol CustomUINavigationTitleDelegate: class {
    //called when view is tapped, will be implemented in view controller acknolwding this protocol/delegate
    func headerWasTapped()
}

class CustomUINavigationTitle: UIView {
    
    //holds CustomUINavigationTitleDelegate object, used to call headerWasTapped for view controller
    weak var delegate: CustomUINavigationTitleDelegate?
    
    @IBOutlet var title: UILabel!
    
    //required inits, call setup func
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    //setup tap gestures
    func setupTap() {
        //create the tap geture recognizer
        let gesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        title.isUserInteractionEnabled = true
        //add it to the view
        title.addGestureRecognizer(gesture)
    }
    //action for tap gesture, simply calls delegate method headerWasTapped
    @objc func viewTapped() {
        delegate?.headerWasTapped()
    }
}
