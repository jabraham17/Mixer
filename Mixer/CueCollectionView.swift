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
    
    var presentingVC: UIViewController?
    
    //the layout to use when in the vertical view
    var verticalLayout: CueCollectionViewLayout {
        //create layout that fills the view
        let layout = CueCollectionViewLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        //define default size of a cell, this will be changed for different size cells
        layout.itemSize = CGSize(width: frame.width, height: verticalCueHeight)
        //spacing between cells
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 3
        
        return layout
    }
    //height for cue cell in vertical mode
    var verticalCueHeight: CGFloat {
        return UIScreen.main.bounds.height / 7
    }
    //height for transition cell in vertical mode
    var verticalTransitionHeight: CGFloat {
        return UIScreen.main.bounds.height / 11
    }
    //the layout to use when in the horizontal view
    var horizontalLayout: CueCollectionViewLayout {
        //create layout that fills the view
        let layout = CueCollectionViewLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        //define default size of a cell, this will be changed for different size cells
        layout.itemSize = CGSize(width: frame.width, height: horizontalCueHeight)
        //spacing between cells
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 3
        
        return layout
    }
    //height for cue cell in horizontal mode
    var horizontalCueHeight: CGFloat {
        return UIScreen.main.bounds.height / 4
    }
    //height for transition cell in horizontal mode
    var horizontalTransitionHeight: CGFloat {
        return UIScreen.main.bounds.height / 6
    }
    
    
    var press: UILongPressGestureRecognizer = UILongPressGestureRecognizer()
    var tap: UITapGestureRecognizer = UITapGestureRecognizer()
    func setup() {
        
        //register cells
        register(CueCell.self, forCellWithReuseIdentifier: "cueCell")
        register(TransitionCell.self, forCellWithReuseIdentifier: "transitionCell")
        
        
        //setup taps for reordering
        press = UILongPressGestureRecognizer(target: self, action: #selector(press(_:)))
        //set time
        press.minimumPressDuration = 0.2
        addGestureRecognizer(press)
        
        //single tap to edit
        tap = UITapGestureRecognizer.init(target: self, action: #selector(tap(_:)))
        addGestureRecognizer(tap)
        
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
        removeGestureRecognizer(press)
        removeGestureRecognizer(tap)
    }
    
    //deal with a long press
    @objc func press(_ gesture: UILongPressGestureRecognizer) {
        
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
            
            //apply the shake
            for cell in visibleCells {
                cell.view(shouldShake: true)
            }
            
            //began moving it
            beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            //every time it is changed updted its position
            updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case .ended:
            //end the movement
            endInteractiveMovement()
            
            //unapply the shake
            for cell in visibleCells {
                cell.view(shouldShake: false)
            }
        default:
            //cancel if somethinf goes wrong
            cancelInteractiveMovement()
        }
    }
    
    //deal with a single tap
    @objc func tap(_ gesture: UITapGestureRecognizer) {
        
        //get the delegae
        let cueDelegate = (delegate as! CueCollectionViewDelegate)
        
        //if its not in editing mode simply return
        if !cueDelegate.isEditing {
            return
        }
        
        //get the item that is selected
        guard let selectedIndexPath = indexPathForItem(at: gesture.location(in: self)) else {
            return
        }
        let dataAtPath = DataManager.instance.shows[cueDelegate.index!].listing[selectedIndexPath.row]
        let cellAtPath = cellForItem(at: selectedIndexPath)
        
        //if its a cue, use the cue edit
        if dataAtPath is Cue {
            let cue = dataAtPath as! Cue
            
            //get the view controller
            let cueEditVC = CueEditVC()
            cueEditVC.cue = cue
            cueEditVC.cueIndex = selectedIndexPath.row
            //set the deleagte
            cueEditVC.delegate = self
            
            //set preferred size for view controller
            cueEditVC.preferredContentSize = CGSize.init(width: 2 * self.frame.width / 3, height: 3 * self.frame.height / 5)
            
            //set the presentation style to popover
            cueEditVC.modalPresentationStyle = .popover
            
            //setup as a popover view controller
            let popover = cueEditVC.popoverPresentationController!
            
            //set the delegate as this class
            popover.delegate = self
            //anchor the popover to the title view
            popover.sourceView = cellAtPath!
            popover.sourceRect = cellAtPath!.bounds
            
            //present the popover
            presentingVC?.present(cueEditVC, animated: true, completion: {
                //set the popovers frame to the frame inside of the presetening view controller so that subviews can be laid out accrodingly
                cueEditVC.frame = popover.frameOfPresentedViewInContainerView
                
                //dont pasd tjeough anyviews
                popover.passthroughViews = nil
            })
        }
        //of its a trans, use the trans edit
        else if dataAtPath is Transition {
            let trans = dataAtPath as! Transition
            
            //get the view controller
            let transEditVC = TransitionEditVC()
            transEditVC.trans = trans
            transEditVC.transIndex = selectedIndexPath.row
            //set the deleagte
            transEditVC.delegate = self
            
            //set preferred size for view controller
            transEditVC.preferredContentSize = CGSize.init(width: 2 * self.frame.width / 3, height: 2 * self.frame.height / 5)
            
            //set the presentation style to popover
            transEditVC.modalPresentationStyle = .popover
            
            //setup as a popover view controller
            let popover = transEditVC.popoverPresentationController!
            
            //set the delegate as this class
            popover.delegate = self
            //anchor the popover to the title view
            popover.sourceView = cellAtPath!
            popover.sourceRect = cellAtPath!.bounds
            
            //present the popover
            presentingVC?.present(transEditVC, animated: true, completion: {
                //set the popovers frame to the frame inside of the presetening view controller so that subviews can be laid out accrodingly
                transEditVC.frame = popover.frameOfPresentedViewInContainerView
                
                //dont pasd tjeough anyviews
                popover.passthroughViews = nil
            })
        }
        
        
    }
    
    //highlight cell at index
    func highlightCell(at index: Int) {
        highlightCell(atPath: IndexPath(row: index, section: 0))
    }
    //highlight cell at indexPath
    func highlightCell(atPath indexPath: IndexPath) {
        let cell = cellForItem(at: indexPath)
        (delegate as! CueCollectionViewDelegate).highlightedCellIndex = indexPath
        highlightedCell = cell
    }
    func unhighlightCells() {
        highlightedCell = nil
    }
    //the cell that is to be highlighted
    private var highlightedCell: UICollectionViewCell? {
        didSet {
            //if there was an old value, reset its background view
            if oldValue != nil {
                if oldValue is CueCell {
                    (oldValue as! CueCell).isHighlighted = false
                }
                else if oldValue is TransitionCell {
                    (oldValue as! TransitionCell).isHighlighted = false
                }
            }
            if highlightedCell != nil {
                if highlightedCell is CueCell {
                    (highlightedCell as! CueCell).isHighlighted = true
                }
                else if highlightedCell is TransitionCell {
                    (highlightedCell as! TransitionCell).isHighlighted = true
                }
            }
        }
    }
    
    
    //when the rotation changes
    @objc func rotate() {
        //orientaion
        let orientation = UIDevice.current.orientation
        //if vertical
        if orientation.isPortrait {
            Global.previousOrientation = orientation
            //set the layot to be the vertucal layout
            collectionViewLayout = verticalLayout
        }
            //if horizonatl
        else if orientation.isLandscape {
            Global.previousOrientation = orientation
            //set the layot to be the horizontal layout
            collectionViewLayout = horizontalLayout
        }
        else {
            //if its flat, use the previous setting
            //if no previous setting, force one
            if Global.previousOrientation == nil {
                let value = UIDeviceOrientation.portrait.rawValue
                UIDevice.current.setValue(value, forKey: "orientation")
            }
            else {
                UIDevice.current.setValue(Global.previousOrientation?.rawValue, forKey: "orientation")
            }
        }
        
    }
    
}

//UIPopoverPresentationControllerDelegate
extension CueCollectionView: UIPopoverPresentationControllerDelegate {
    //present in popover style
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    //only dismissal through buttons
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return false
    }
}

//dleegate methods from the cue edit view
extension CueCollectionView: CueEditDelegate {
    func closed(cueIndex: Int, cue: Cue) {
        //get the delegae
        let cueDelegate = (delegate as! CueCollectionViewDelegate)
        //update cue at index and reload
        DataManager.instance.shows[cueDelegate.index!].listing[cueIndex] = cue
        DataManager.instance.save()
        reloadData()
    }
    func delete(cueIndex: Int) {
        //get the delegae
        let cueDelegate = (delegate as! CueCollectionViewDelegate)
        DataManager.instance.shows[cueDelegate.index!].listing.remove(at: cueIndex)
        DataManager.instance.save()
        reloadData()
    }
}

//dleegate methods from the trans edit view
extension CueCollectionView: TransitionEditDelegate {
    func closed(transIndex: Int, trans: Transition) {
        //get the delegae
        let cueDelegate = (delegate as! CueCollectionViewDelegate)
        //update cue at index and reload
        DataManager.instance.shows[cueDelegate.index!].listing[transIndex] = trans
        DataManager.instance.save()
        reloadData()
    }
    func delete(transIndex: Int) {
        //get the delegae
        let cueDelegate = (delegate as! CueCollectionViewDelegate)
        DataManager.instance.shows[cueDelegate.index!].listing.remove(at: transIndex)
        DataManager.instance.save()
        reloadData()
    }
}


extension UIView {
    //make cells shake when moving
    func view(shouldShake: Bool) {
        
        //if it shoudl shake, make it shake
        if shouldShake {
            let shakeAnimation = CABasicAnimation(keyPath: "transform.rotation")
            shakeAnimation.duration = 0.1
            //go back and forth
            let rotateBy = (Double.pi / 128)
            shakeAnimation.fromValue = -rotateBy
            shakeAnimation.toValue = rotateBy
            //make the shaking go forever
            shakeAnimation.autoreverses = true
            shakeAnimation.repeatCount = .infinity
            //add shaking
            layer.add(shakeAnimation, forKey: "shake")
        }
        //otherwise, stop shaking
        else {
            layer.removeAnimation(forKey: "shake")
        }
    }
}
