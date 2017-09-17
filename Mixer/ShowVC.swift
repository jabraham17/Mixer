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
class ShowVC: UIViewController {

    //refrence to collection view, used to show and edit cells
    @IBOutlet var cueView: UICollectionView!
    //refrence to add button, used to toggle appearnace
    @IBOutlet var addButton: UIBarButtonItem!
    //refrence to play button, used to add pulse
    @IBOutlet var playButton: UIButton!
    
    
    
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
    

}

