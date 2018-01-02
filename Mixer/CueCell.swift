//
//  CueCell.swift
//  Mixer
//
//  Created by Jacob R. Abraham on 9/10/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import UIKit

//custom cell for the collection view on ShowVC
@IBDesignable class CueCell: UICollectionViewCell {
    
    @IBOutlet var preAction: UILabel!
    @IBOutlet var cueNumber: UILabel!
    @IBOutlet var mediaName: UILabel!
    @IBOutlet var script: UILabel!
    @IBOutlet var postAction: UILabel!
    var containerView: UIView!
    
    var data: Cue? {
        didSet {
            preAction.text = data?.preAction.getFormattedName()
            cueNumber.text = "Cue: \(data?.number ?? 0)"
            mediaName.text = "    \(data?.media.getFormattedName() ?? "No Media")"
            script.text = "    \(data?.script ?? "No Script")"
            postAction.text = data?.postAction.getFormattedName()
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
