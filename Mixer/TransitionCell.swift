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
    
    var transition: UILabel?
    
    var data: Transition? {
        didSet {
            transition?.text = data?.name
            
            //set the font to bold after text has been set
            let fontSize = transition?.font.pointSize
            transition?.font = UIFont.boldSystemFont(ofSize: fontSize!)
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            if(isHighlighted) {
                //highlight
                self.backgroundColor = UIColor(red: 0, green: 1, blue: 1, alpha: 1)
            }
            else {
                //unhighlight
                self.backgroundColor = UIColor.lightText
            }
        }
    }
    
    //required inits, call setup func
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //setup the nib
        setup(with: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        //setup the nib
        setup(with: frame)
    }
    //setup the nib
    func setup(with frame: CGRect) {
        
        //values to assist in creating framed for view elements
        let dividingLine = bounds.height
        let spacing: CGFloat = 20.0;
        let width = bounds.width - spacing
        
        //view to show preaction
        transition = UILabel(frame: CGRect(x: spacing, y: 0, width: width, height: dividingLine))
        //set the text to the action
        transition?.text = "Transition"
        //setup format of label
        transition?.numberOfLines = 0
        transition?.lineBreakMode = .byClipping
        transition?.textAlignment = .left
        
        self.contentView.addSubview(transition!)
        
        //default background color
        self.backgroundColor = UIColor.lightText
    }

}
