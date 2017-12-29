//
//  CueCollectionViewDelegate.swift
//  Mixer
//
//  Created by Jacob R. Abraham on 9/21/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import UIKit

//delegate for cue collection view
class CueCollectionViewDelegate: NSObject, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    //show to display
    var show: Show?
    
    //init
    init(show: Show) {
        self.show = show
    }
    //default init
    override init() {
        show = nil
    }
    
    //number of cues to display
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return show?.listing.count ?? 0
    }
    //define the cell at the index
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //the cell to be returned
        var cell: UICollectionViewCell
        
        //get the data
        let cueData = show?.listing[indexPath.row]
        //if its a transtion
        if cueData is Transition {
            //get the cell
            let transCell = collectionView.dequeueReusableCell(withReuseIdentifier: "transitionCell", for: indexPath) as! TransitionCell
            //get the data and apply it
            transCell.data = cueData as? Transition
            
            //change return value
            cell = transCell
        }
        else if cueData is Cue {
            //get the cell
            let cueCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cueCell", for: indexPath) as! CueCell
            //get the data and apply it
            cueCell.data = cueData as? Cue
            
            //change return value
            cell = cueCell
        }
        else {
            //dont do anything
            cell = UICollectionViewCell()
        }
        
        return cell
    }
    //size for the cell at index
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //get the data
        let cueData = show?.listing[indexPath.row]
        let isTrans = cueData is Transition
        
        //first the orietnation must be determined
        let orientation = UIDevice.current.orientation
        //if vertical
        if UIDeviceOrientationIsPortrait(orientation) {
            //if the index is a transition cell, change the size to vertical transuton size, otherwise do nothng
            if isTrans {
                return CGSize(width: collectionView.frame.width, height: (collectionView as! CueCollectionView).verticalTransitionHeight)
            }
                //otherwise return the vertical cue size
            else {
                return CGSize(width: collectionView.frame.width, height: (collectionView as! CueCollectionView).verticalCueHeight)
            }
            
        }
            //if horizonatl
        else if UIDeviceOrientationIsLandscape(orientation) {
            //if the index is a transition cell, change the size to horizonatl transuton size, otherwise do nothng
            if isTrans {
                return CGSize(width: collectionView.frame.width, height: (collectionView as! CueCollectionView).horizontalTransitionHeight)
            }
                //otherwise return the horizonatl cue size
            else {
                return CGSize(width: collectionView.frame.width, height: (collectionView as! CueCollectionView).horizontalCueHeight)
            }
        }
        
        //if no match is found, then the defualt size is used
        return CGSize()
    }
}
