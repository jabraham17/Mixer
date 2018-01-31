//
//  CueCell.swift
//  Mixer
//
//  Created by Jacob R. Abraham on 9/10/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import UIKit

//custom cell for the collection view on ShowVC
class CueCell: UICollectionViewCell {
    
    var preAction: UILabel?
    var cueName: UILabel?
    var mediaName: UILabel?
    var script: UILabel?
    var postAction: UILabel?
    
    var data: Cue? {
        didSet {
            //TODO: make it show text when displaying with no script or no media
            preAction?.text = data?.preAction.getFormattedName()
            cueName?.text = data?.name
            mediaName?.text = "\(data?.media.getFormattedName() ?? "No Media")"
            script?.text = "\(data?.script ?? "No Script")"
            postAction?.text = data?.postAction.getFormattedName()
            
            //set the font to bold after text has been set
            let fontSize = cueName?.font.pointSize
            cueName?.font = UIFont.boldSystemFont(ofSize: fontSize!)
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
        let dividingLine = bounds.height / 5
        let spacing: CGFloat = 20.0;
        let width = bounds.width - spacing
        
        //view to show preaction
        preAction = UILabel(frame: CGRect(x: spacing, y: 0, width: width, height: dividingLine))
        //set the text to the action
        preAction?.text = "Pre Action"
        //setup format of label
        preAction?.numberOfLines = 0
        preAction?.lineBreakMode = .byClipping
        preAction?.textAlignment = .left
        
        //view to show cue name
        cueName = UILabel(frame: CGRect(x: spacing, y: dividingLine, width: width, height: dividingLine))
        //set the text to the action
        cueName?.text = "Cue Name"
        //setup format of label
        cueName?.numberOfLines = 0
        cueName?.lineBreakMode = .byClipping
        cueName?.textAlignment = .left
        
        //view to show media name
        mediaName = UILabel(frame: CGRect(x: 2 * spacing, y: 2 * dividingLine, width: width - spacing, height: dividingLine))
        //set the text to the action
        mediaName?.text = "Media Name"
        //setup format of label
        mediaName?.numberOfLines = 0
        mediaName?.lineBreakMode = .byClipping
        mediaName?.textAlignment = .left
        
        //view to show script
        script = UILabel(frame: CGRect(x: 2 * spacing, y: 3 * dividingLine, width: width - spacing, height: dividingLine))
        //set the text to the action
        script?.text = "Script"
        //setup format of label
        script?.numberOfLines = 0
        script?.lineBreakMode = .byClipping
        script?.textAlignment = .left
        
        //view to show postAction
        postAction = UILabel(frame: CGRect(x: spacing, y: 4 * dividingLine, width: width, height: dividingLine))
        //set the text to the action
        postAction?.text = "Post Action"
        //setup format of label
        postAction?.numberOfLines = 0
        postAction?.lineBreakMode = .byClipping
        postAction?.textAlignment = .left
        
        
        
        //add views to contoller
        self.contentView.addSubviews(preAction!, cueName!, mediaName!, script!, postAction!)
    }
    
}
