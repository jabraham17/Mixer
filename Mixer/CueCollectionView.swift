//
//  CueCollectionView.swift
//  
//
//  Created by Jacob R. Abraham on 9/16/17.
//
//
import UIKit

//custom collection view for use in play and show vc
@IBDesignable class CueCollectionView: UICollectionView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
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
        return frame.height / 6
    }
    //height for transition cell in vertical mode
    final var verticalTransitionHeight: CGFloat {
        return frame.height / 16
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
        return frame.height / 4
    }
    //height for transition cell in horizontal mode
    final var horizontalTransitionHeight: CGFloat {
        return frame.height / 10
    }
    
    func setup() {
        
        //register cells
        register(UINib(nibName: "CueCell", bundle: .main), forCellWithReuseIdentifier: "cueCell")
        register(UINib(nibName: "TransitionCell", bundle: .main), forCellWithReuseIdentifier: "transitionCell")
        
        //add listener to changes for roattion
        NotificationCenter.default.addObserver(self, selector: #selector(rotate), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        //call rotate method to set the current orientation
        rotate()
        
        //set delegates for view
        delegate = self
        dataSource = self
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
    
    //when the rotation changes
    func rotate() {
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
                return CGSize(width: collectionView.frame.width, height: verticalTransitionHeight)
            }
                //otherwise return the vertical cue size
            else {
                return CGSize(width: collectionView.frame.width, height: verticalCueHeight)
            }
            
        }
            //if horizonatl
        else if UIDeviceOrientationIsLandscape(orientation) {
            //if the index is a transition cell, change the size to horizonatl transuton size, otherwise do nothng
            if indexPath.row == 1 || indexPath.row == 3 {
                return CGSize(width: collectionView.frame.width, height: horizontalTransitionHeight)
            }
                //otherwise return the horizonatl cue size
            else {
                return CGSize(width: collectionView.frame.width, height: horizontalCueHeight)
            }
        }
        
        //if no match is found, then the defualt size is used
        return CGSize()
    }
    
    
}


