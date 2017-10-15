//
//  PlayVC.swift
//  Mixer
//
//  Created by Jacob R. Abraham on 8/29/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import UIKit

//view controller for the view that displays the show when it is running
class PlayVC: UIViewController {
    
    //refrence to collection view, used to display all cues
    @IBOutlet var cueView: CueCollectionView!
    
    //refrence to lock button, used to toggle appearnace
    @IBOutlet var lockButton: UIBarButtonItem!
    
    //refrence to time label, used to update time to current time
    @IBOutlet var showTimeLabel: UILabel!
    
    //refrence to current cue label, used to change title of current cue
    @IBOutlet var currentCueLabel: UILabel!
    //refrence to progress view, used to update the value as time progresses
    @IBOutlet var currentCueProgress: UIProgressView!
    //refrence to current time label, used to show current time of current cue
    @IBOutlet var cueCurrentTimeLabel: UILabel!
    //refrence to end time label, used to show total time of certain cue
    @IBOutlet var cueEndTimeLabel: UILabel!
    
    //deleagte for cueView
    var delegate: CueCollectionViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set the coolection view deleagtes
        cueView.delegate = delegate
        cueView.dataSource = delegate
        
    }
    //action for lock button
    @IBAction func lockAction(_ sender: UIBarButtonItem) {
    }
    //action for go button
    @IBAction func goAction(_ sender: UIButton) {
    }
    //action for previous button
    @IBAction func previousAction(_ sender: UIButton) {
    }
    //action for redo button
    @IBAction func redoAction(_ sender: UIButton) {
    }
    //action for pause button
    @IBAction func pauseAction(_ sender: UIButton) {
    }
}
