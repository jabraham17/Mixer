//
//  CueCollectionView.swift
//  
//
//  Created by Jacob R. Abraham on 9/16/17.
//
//
import UIKit

//custom collection view for use in play and show vc
@IBDesignable class CueCollectionView: UICollectionView {
    
    //the layout to use when in the vertical view
    final var verticalLayout: UICollectionViewFlowLayout {
        //create layout that fills the view
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        //define default size of a cell, this will be changed for different size cells
        layout.itemSize = CGSize(width: frame.width, height: verticalCueHeight)
        //spacing between cells
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 3
        
        return layout
    }
    //height for cue cell in vertical mode
    final var verticalCueHeight: CGFloat {
        return Global.screenHeight / 6
    }
    //height for transition cell in vertical mode
    final var verticalTransitionHeight: CGFloat {
        return Global.screenHeight / 16
    }
    //the layout to use when in the horizontal view
    final var horizontalLayout: UICollectionViewFlowLayout {
        //create layout that fills the view
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        //define default size of a cell, this will be changed for different size cells
        layout.itemSize = CGSize(width: frame.width, height: horizontalCueHeight)
        //spacing between cells
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 3
        
        return layout
    }
    //height for cue cell in horizontal mode
    final var horizontalCueHeight: CGFloat {
        return Global.screenHeight / 4
    }
    //height for transition cell in horizontal mode
    final var horizontalTransitionHeight: CGFloat {
        return Global.screenHeight / 10
    }
    
    func setup() {
        
        //register cells
        register(CueCell.self, forCellWithReuseIdentifier: "cueCell")
        register(TransitionCell.self, forCellWithReuseIdentifier: "transitionCell")
        
        //TODO: setup divider line
        
        
        //setup taps for reordering
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:)))
        addGestureRecognizer(longPressGesture)
        
        //add listener to changes for roattion
        NotificationCenter.default.addObserver(self, selector: #selector(rotate), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        //call rotate method to set the current orientation
        rotate()
    }
    //inits, call setp func
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setup()
    }
    //when view goes away, remove the listener
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //deal with a long press
    @objc func longPress(_ gesture: UILongPressGestureRecognizer) {
        
        //if its not in editing mode simply return
        if !(delegate as! CueCollectionViewDelegate).isEditing {
            return
        }
        
        //get the gestures state
        switch(gesture.state) {
            
        case .began:
            //get the item that is selected
            guard let selectedIndexPath = indexPathForItem(at: gesture.location(in: self)) else {
                break
            }
            //began moving it
            beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            print("Changing")
            //every time it is changed updted its position
            updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case .ended:
            //end the movement
            endInteractiveMovement()
        default:
            //cancel if somethinf goes wrong
            cancelInteractiveMovement()
        }
    }
    
    //when the rotation changes
    @objc func rotate() {
        //orientaion
        let orientation = UIDevice.current.orientation
        //if vertical
        if UIDeviceOrientationIsPortrait(orientation) {
            //set the layot to be the vertucal layout
            collectionViewLayout = verticalLayout
        }
            //if horizonatl
        else if UIDeviceOrientationIsLandscape(orientation) {
            //set the layot to be the horizontal layout
            collectionViewLayout = horizontalLayout
        }
    }
    
}

