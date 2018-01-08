//
//  TransitionCell.swift
//  Mixer
//
//  Created by Jacob R. Abraham on 9/13/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import UIKit

//TODO: need to show what kind of transition it is

//custom cell for the collection view on ShowVC
@IBDesignable class TransitionCell: UICollectionViewCell {
    
    @IBOutlet var transition: UILabel!
    var containerView: UIView!
    
    var data: Transition? {
        didSet {
            transition.text = data?.name
        }
    }
    
    //required inits, call setup func
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //setup the nib
        setupNib()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        //setup the nib
        setupNib()
    }
    //setup the nib
    func setupNib() {
        //get the nib as a view
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        containerView = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        //set the content view so that it is the same size as the view
        containerView.frame = bounds
        
        //setup view so that if screen is resized the view stretches with it
        containerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.addSubview(containerView)
    }

}
