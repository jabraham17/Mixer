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
    
    //refrence to current cue label, used to change title of current cue
    @IBOutlet var currentCueLabel: UILabel!
    //refrence to progress view, used to update the value as time progresses
    @IBOutlet var currentCueProgress: UIProgressView!
    //refrence to current time label, used to show current time of current cue
    @IBOutlet var cueCurrentTimeLabel: UILabel!
    //refrence to end time label, used to show total time of certain cue
    @IBOutlet var cueEndTimeLabel: UILabel!
    
    //deleagte for cueView
    var delegate: CueCollectionViewDelegate? {
        didSet {
            listing = DataManager.instance.shows[delegate!.index!].listing
        }
    }
    
    //get the lisiting of cues
    var listing: [GenericCue]?
    
    //index of the current cue
    var currentCueIndex: Int? {
        didSet {
            //if new value wont fit
            //TODO: if value leaves the legnth of the array, end the show
            if currentCueIndex! >= listing!.count || currentCueIndex! < 0 {
                //reset to old value
                currentCueIndex = oldValue
            }
            else {
                currentCue = listing![currentCueIndex!]
            }
        }
    }
    //the currnt cue
    private var currentCue: GenericCue? {
        didSet {
            currentCueLabel?.text = "\(currentCue?.name ?? "")"
            
            cueView?.highlightCell(at: currentCueIndex ?? 0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set the coolection view deleagtes
        cueView.delegate = delegate
        cueView.dataSource = delegate
        
        currentCueLabel?.text = "\(currentCue?.name ?? "")"
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        cueView?.highlightCell(at: currentCueIndex ?? 0)
        
    }
    //action for go button
    @IBAction func goAction(_ sender: UIButton) {
        //FIXME: just for testing
        currentCueIndex! += 1
    }
    //action for previous button
    @IBAction func previousAction(_ sender: UIButton) {
        //FIXME: just for testing
        currentCueIndex! -= 1
    }
    //action for pause button
    @IBAction func pauseAction(_ sender: UIButton) {
    }
    @IBOutlet var VerticalOutlets: [NSLayoutConstraint]!
}
