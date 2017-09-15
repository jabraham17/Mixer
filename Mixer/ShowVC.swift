//
//  ViewController.swift
//  Mixer
//
//  Created by Jacob R. Abraham on 8/28/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import UIKit
import SideMenu

//view controller for the opening view, which displays the show
class ShowVC: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    //refrence to collection view, used to show and edit cells
    @IBOutlet var cueView: UICollectionView!
    //refrence to add button, used to toggle appearnace
    @IBOutlet var addButton: UIBarButtonItem!
    //refrence to play button, used to add pulse
    @IBOutlet var playButton: UIButton!
    
    //the layout to use when in the vertical view
    final var verticalLayout: UICollectionViewFlowLayout {
        //create layout that fills the view
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        //define default size of a cell, this will be changed for different size cells
        layout.itemSize = CGSize(width: cueView.frame.width, height: verticalCueHeight)
        //spacing between cells
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 3

        return layout
    }
    //height for cue cell in vertical mode
    final var verticalCueHeight: CGFloat {
        return cueView.frame.height / 6
    }
    //height for transition cell in vertical mode
    final var verticalTransitionHeight: CGFloat {
        return cueView.frame.height / 16
    }
    //the layout to use when in the horizontal view
    final var horizontalLayout: UICollectionViewFlowLayout {
        //create layout that fills the view
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        //define default size of a cell, this will be changed for different size cells
        layout.itemSize = CGSize(width: cueView.frame.width, height: horizontalCueHeight)
        //spacing between cells
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 3
        
        return layout
    }
    //height for cue cell in horizontal mode
    final var horizontalCueHeight: CGFloat {
        return cueView.frame.height / 4
    }
    //height for transition cell in horizontal mode
    final var horizontalTransitionHeight: CGFloat {
        return cueView.frame.height / 10
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //add pulse to button
        let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
        //let pulse go for 1 second
        pulseAnimation.duration = 2
        //go from a little below actual size to a little above
        pulseAnimation.fromValue = 0.95
        pulseAnimation.toValue = 1.05
        //set the timing animation
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        //make the pulse go forever
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = .infinity
        //add pulse to layer of button
        playButton.layer.add(pulseAnimation, forKey: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //add listener to changes for roattion
        NotificationCenter.default.addObserver(self, selector: #selector(rotate), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        //call rotate method to set the current orientation
        rotate()
        
        //set delegates for cueView
        cueView.delegate = self
        cueView.dataSource = self
        
        //view loads with add button not visible
        //FIXME: unable to hide add button, functionaailty not native, need to add
        
        //load in the menu from the storyboard
         let menuNC = storyboard!.instantiateViewController(withIdentifier: "HamburgerMenuNaviagtionController") as! UISideMenuNavigationController
        //set the menu as a left side menu
        menuNC.leftSide = true
        //add the menu to the manager
        SideMenuManager.menuLeftNavigationController = menuNC
        
        //add gesture recognizors to the menu manager
        SideMenuManager.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        
        //set the animation for the menu
        SideMenuManager.menuPresentMode = .menuSlideIn
        //force status bar to stay visible
        SideMenuManager.menuFadeStatusBar = false
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
            cueView.collectionViewLayout = verticalLayout
        }
        //if horizonatl
        else if UIDeviceOrientationIsLandscape(orientation) {
            //set the layot to be the horizontal layout
            cueView.collectionViewLayout = horizontalLayout
        }
    }
    
    //catch and modify the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //TODO: add any customization to segue
    }
    //action to show the menu
    @IBAction func hamburgerMenuAction(_ sender: UIBarButtonItem) {
        present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
    }
    //action for add button in edit mode
    @IBAction func addAction(_ sender: UIBarButtonItem) {
    }
    //action for the edit/done button
    @IBAction func editDoneAction(_ sender: UIBarButtonItem) {
    }
    //action for the play button
    @IBAction func playAction(_ sender: UIButton) {
        //go to the play view
        self.performSegue(withIdentifier: "ShowToPlaySegue", sender: nil)
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

