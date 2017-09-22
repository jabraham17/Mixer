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
    
    //number of cues to display
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    //define the cell at the index
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //if row is transiton, deque transition cell
        //TODO: temp code to test functionalyut
        if indexPath.row == 1 || indexPath.row == 3 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "transitionCell", for: indexPath) as! TransitionCell
            
            return cell
        }
            //otherwise deque cue cell
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cueCell", for: indexPath) as! CueCell
            
            return cell
        }
    }
    //size for the cell at index
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //first the orietnation must be determined\
        let orientation = UIDevice.current.orientation
        //if vertical
        if UIDeviceOrientationIsPortrait(orientation) {
            //if the index is a transition cell, change the size to vertical transuton size, otherwise do nothng
            if indexPath.row == 1 || indexPath.row == 3 {
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
            if indexPath.row == 1 || indexPath.row == 3 {
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
