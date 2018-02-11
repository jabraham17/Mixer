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
    @IBOutlet var cueView: CueCollectionView!
    //refrence to add button, used to toggle appearnace
    @IBOutlet var addButton: UIBarButtonItem!
    //refrence to play button, used to add pulse
    @IBOutlet var playButton: UIButton!
    
    //wether the show is being edited or not
    var editingMode: Bool = false {
        didSet {
            //update the delegates editing
            delegate.isEditing = editingMode
            cueView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //set title of screen to show
        (self.navigationItem.titleView as! CustomUINavigationTitle).title.text = getShow() == nil ? "" : getShow()?.name
        
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
    
    //deleagte for cueView
    let delegate = CueCollectionViewDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        (self.navigationItem.titleView as! CustomUINavigationTitle).setupTap()
        
        //view loads with add button not visible
        addButton.hide()
        
        //load in the menu from the storyboard
         let menuNC = storyboard!.instantiateViewController(withIdentifier: "HamburgerMenuNaviagtionController") as! UISideMenuNavigationController
        //set delagte
        (menuNC.topViewController as! MenuVC).passingDelegate = self
        //set the menu as a left side menu
        menuNC.leftSide = true
        //add the menu to the manager
        SideMenuManager.default.menuLeftNavigationController = menuNC
        
        //add gesture recognizor to the menu manager
        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.view)
        
        //set the animation for the menu
        SideMenuManager.default.menuPresentMode = .menuSlideIn
        //force status bar to stay visible
        SideMenuManager.default.menuFadeStatusBar = false
        //width of the menu, should be 80%
        SideMenuManager.default.menuWidth = Global.screenWidth * 0.8
        
        delegate.index = nil
        
        //set the coolection view deleagtes
        cueView.delegate = delegate
        cueView.dataSource = delegate
        //presenting view controller
        cueView.presentingVC = self
        
        //add tap gesture deleagte to title
        (self.navigationItem.titleView as! CustomUINavigationTitle).delegate = self
        
        //start showing the menu
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    //catch and modify the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //pass delegate and show
        let vc = segue.destination as! PlayVC
        vc.delegate = delegate
        vc.currentCueIndex = 0
        
    }
    //action to show the menu
    @IBAction func hamburgerMenuAction(_ sender: UIBarButtonItem) {
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    //action for add button in edit mode
    @IBAction func addAction(_ sender: UIBarButtonItem) {
        if(editingMode) {
            //open a cue add view
            //get the view controller
            let cueAddVC = CueAddVC()
            //set the delegate
            cueAddVC.delegate = self
            
            //set preferred size for view controller
            cueAddVC.preferredContentSize = CGSize.init(width: 2 * self.view.frame.width / 3, height: 3 * self.view.frame.height / 5)
            
            //set the presentation style to popover
            cueAddVC.modalPresentationStyle = .popover
            
            //setup as a popover view controller
            let popover = cueAddVC.popoverPresentationController!
            
            //set the delegate as this class
            popover.delegate = self
            //anchor to the view, this makes it function like a popup instad of a popover
            popover.sourceView = self.view
            popover.sourceRect = self.view.bounds
            //dont show any arrows
            popover.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
            
            //present the popover
            present(cueAddVC, animated: true, completion: {
                //set the popovers frame to the frame inside of the presetening view controller so that subviews can be laid out accrodingly
                cueAddVC.frame = popover.frameOfPresentedViewInContainerView
                
                //dont pasd tjeough anyviews
                popover.passthroughViews = nil
            })
        }
    }
    //action for the edit/done button
    @IBAction func editDoneAction(_ sender: UIBarButtonItem) {
        //get text of button
        let title = sender.title
        if(title == "Edit") {
            sender.title = "Done"
            editingMode = true
            addButton.show()
        }
        else if(title == "Done") {
            sender.title = "Edit"
            editingMode = false
            addButton.hide()
            
            //save data
            DataManager.instance.save()
        }
    }
    //action for the play button
    @IBAction func playAction(_ sender: UIButton) {
        //signal show to run
        DataManager.instance.shows[delegate.index!].run()
        //go to the play view
        self.performSegue(withIdentifier: "ShowToPlaySegue", sender: nil)
    }
    
    //get the show from the delegate
    func getShow() -> Show? {
        if(delegate.index == nil)
        {
            return nil
        }
        return DataManager.instance.shows[delegate.index!]
    }
}

//Menu Delegate
extension ShowVC: MenuVCDelegate {
    //deleagte from Menu
    func showSelected(index: Int) {
        delegate.index = index
        //set title of screen to show
        (self.navigationItem.titleView as! CustomUINavigationTitle).title.text = getShow() == nil ? "" : getShow()?.name
        //reload the data
        cueView.reloadData()
    }
}

//Header Deleagte
extension ShowVC: CustomUINavigationTitleDelegate {
    //when title is tapped, show information view with dates
    func headerWasTapped() {
        //get the view controller
        let showInfoVC = ShowInfoVC()
        showInfoVC.index = delegate.index
        //set the deleagte
        showInfoVC.delegate = self
        
        //set preferred size for view controller
        showInfoVC.preferredContentSize = CGSize.init(width: self.view.frame.width / 2, height: self.view.frame.height / 4)
        
        //set the presentation style to popover
        showInfoVC.modalPresentationStyle = .popover
        
        //setup as a popover view controller
        let popover = showInfoVC.popoverPresentationController!
        
        //set the delegate as this class
        popover.delegate = self
        //anchor the popover to the title view
        popover.sourceView = self.navigationItem.titleView
        popover.sourceRect = (self.navigationItem.titleView?.bounds)!
        
        //present the popover
        present(showInfoVC, animated: true, completion: {
            //set the popovers frame to the frame inside of the presetening view controller so that subviews can be laid out accrodingly
            showInfoVC.frame = popover.frameOfPresentedViewInContainerView
            
            //dont pasd tjeough anyviews
            popover.passthroughViews = nil
        })
    }
}


//CueAddDelegate
extension ShowVC: CueAddDelegate {
    //recieve the show from the CueAdd
    func closed(cue: GenericCue) {
       DataManager.instance.shows[delegate.index!].add(cue: cue)
        
        //refresh
        cueView.reloadData()
    }
}

//ShowInfoDelegate
extension ShowVC: ShowInfoDelegate {
    //recieve the show from the ShowInfo
    func closed() {
        //refresh
        cueView.reloadData()
        
        //set title of screen to show
        (self.navigationItem.titleView as! CustomUINavigationTitle).title.text = getShow() == nil ? "" : getShow()?.name
    }
}

//UIPopoverPresentationControllerDelegate
extension ShowVC: UIPopoverPresentationControllerDelegate {
    //present in popover style
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    //only dismissal through buttons
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return false
    }
}


extension UIBarButtonItem {
    func hide() {
        isEnabled = false
        tintColor = .clear
    }
    func show() {
        isEnabled = true
        tintColor = nil
    }
}

