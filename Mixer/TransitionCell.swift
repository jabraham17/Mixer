//
//  TransitionCell.swift
//  Mixer
//
//  Created by Jacob R. Abraham on 9/13/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import UIKit

//custom cell for the collection view on ShowVC
@IBDesignable class TransitionCell: UICollectionViewCell {
    
    var transition: UILabel?
    var type: UILabel?
    var script: UILabel?
    
    var data: Transition? {
        didSet {
            transition?.text = data?.name
            type?.text = data?.transition.type.description
            script?.text = data?.script
            
            //set the font to bold after text has been set
            let fontSize = transition?.font.pointSize
            transition?.font = UIFont.boldSystemFont(ofSize: fontSize!)
            
            recolor()
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            recolor()
        }
    }
    func recolor() {
        if(isHighlighted) {
            //highlight
            self.backgroundColor = UIColor(red: 0, green: 1, blue: 1, alpha: 1)
        }
        else {
            //unhighlight
            self.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 0.6)
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
        let dividingLine = bounds.height / 3
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
        
        //view to show media name
        type = UILabel(frame: CGRect(x: 2 * spacing, y: dividingLine, width: width - spacing, height: dividingLine))
        //set the text to the action
        type?.text = "Transition Type"
        //setup format of label
        type?.numberOfLines = 0
        type?.lineBreakMode = .byClipping
        type?.textAlignment = .left
        
        //view to show script
        script = UILabel(frame: CGRect(x: 2 * spacing, y: 2 * dividingLine, width: width - spacing, height: dividingLine))
        //set the text to the action
        script?.text = "Script"
        //setup format of label
        script?.numberOfLines = 0
        script?.lineBreakMode = .byClipping
        script?.textAlignment = .left
        
        self.contentView.addSubviews(transition!, type!, script!)
        
        //recolor
        recolor()
    }

}
