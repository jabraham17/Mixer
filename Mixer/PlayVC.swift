//
//  PlayVC.swift
//  Mixer
//
//  Created by Jacob R. Abraham on 8/29/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import UIKit
import AVFoundation

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
    
    //format the time as hh:ss
    func format(_ time: TimeInterval) -> String {
        //convert time to int
        let totalSeconds = Int(time)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    var textTimer: Timer?
    
    //update the progress of the cue for the user
    @objc func updateProgress() {
        if currentCue is Cue {
            let cue = (currentCue as! Cue)
            if cue.isDonePlaying {
                resetProgress()
                currentCueIndex! += 1
            }
            else {
                cueEndTimeLabel?.text = format((cue.cuePlayer?.duration)!)
                cueCurrentTimeLabel?.text = format((cue.cuePlayer?.currentTime)!)
                currentCueProgress?.progress = cue.computeProgress()
            }
        }
        else if currentCue is Transition {
            let trans = currentCue as! Transition
            if trans.transition.type == .Pause {
                cueEndTimeLabel?.text = "Pause"
                cueCurrentTimeLabel?.text = "Pause"
                currentCueProgress?.progress = 0
            }
            else if trans.transition.type == .Wait {
                if trans.currentTime >= trans.transition.time {
                    trans.currentTime = 0.0
                    resetProgress()
                    currentCueIndex! += 1
                }
                else {
                    cueEndTimeLabel?.text = format(trans.transition.time)
                    cueCurrentTimeLabel?.text = format(trans.currentTime)
                    currentCueProgress?.progress = trans.computeProgress()
                    trans.currentTime += 1.0
                }
            }
        }
    }
    func resetProgress() {
        cueEndTimeLabel?.text = "00:00"
        cueCurrentTimeLabel?.text = "00:00"
        currentCueProgress?.progress = 0
    }
    
    func togglePauseAudio() {
        if currentCue is Cue {
            let cue = (currentCue as! Cue)
            cue.pauseToggle()
            AudioFader.toggle()
        }
    }
    
    func stopAudio() {
        //cleanup old fader
        AudioFader.cleanup()
        if currentCue is Cue {
            let cue = (currentCue as! Cue)
            cue.stop()
            cue.unload()
            textTimer?.invalidate()
            resetProgress()
        }
    }
    
    //get the lisiting of cues
    var listing: [GenericCue]?
    
    //index of the current cue
    var currentCueIndex: Int? {
        didSet {
            //if new value wont fit
            //if new value goes below 0, reset to oldValue
            if currentCueIndex! < 0 {
                //reset to old value
                currentCueIndex = oldValue
            }
            //if leave the end of the show, end show
            if currentCueIndex! >= listing!.count {
                endShow()
            }
            else {
                currentCue = listing![currentCueIndex!]
            }
        }
    }
    //the currnt cue
    private var currentCue: GenericCue? {
        didSet {
            //stop the previous cue
            stopAudio()
            
            currentCueLabel?.text = "\(currentCue?.name ?? "")"
            
            cueView?.highlightCell(at: currentCueIndex ?? 0)
            
            //if the previous cue was a Cue, unload it
            if(oldValue is Cue) {
                let cue = (oldValue as! Cue)
                //invalidate stufff
                textTimer?.invalidate()
                resetProgress()
                cue.stop()
                cue.unload()
            }
            else if oldValue is Transition {
                let trans = (oldValue as! Transition)
                textTimer?.invalidate()
                resetProgress()
                trans.currentTime = 0
            }
            
            //load a cue and play it
            if(currentCue is Cue)
            {
                let cue = (currentCue as! Cue)
                //init a timer
                textTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
                cue.load()
                cue.play()
            }
            else if(currentCue is Transition){
                //init a timer
                textTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set the coolection view deleagtes
        cueView.delegate = delegate
        cueView.dataSource = delegate
        
        currentCueLabel?.text = "\(currentCue?.name ?? "")"
        
        //set the progress to 0
        currentCueProgress.progress = 0;
        
        //set title of page
        self.navigationItem.title = DataManager.instance.shows[delegate!.index!].name
        
        //setup custom action on back button
        let backButton = UIBarButtonItem(title: "End Playback", style: .plain, target: self, action: #selector(endShow))
        self.navigationItem.hidesBackButton = true
        self.navigationItem.setLeftBarButton(backButton, animated: false)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        cueView?.highlightCell(at: currentCueIndex ?? 0)
    }
    //action for go button
    @IBAction func goAction(_ sender: UIButton) {
        textTimer?.invalidate()
        //reset pause button so it doesnt get screwed up
        if(sender.titleLabel?.text == "RESUME") {
            sender.setTitle("PAUSE", for: .normal)
        }
        resetProgress()
        currentCueIndex! += 1
    }
    //action for previous button
    @IBAction func previousAction(_ sender: UIButton) {
        textTimer?.invalidate()
        resetProgress()
        currentCueIndex! -= 1
    }
    //action for pause button
    @IBAction func pauseAction(_ sender: UIButton) {
        if currentCue is Transition {
            //skip if transitoon, cant pause them
            return
        }
        if(sender.titleLabel?.text == "PAUSE") {
            sender.setTitle("RESUME", for: .normal)
        }
        else {
            sender.setTitle("PAUSE", for: .normal)
        }
        togglePauseAudio()
    }
    
    @objc func endShow() {
        textTimer?.invalidate()
        resetProgress()
        stopAudio()
        goBack()
    }
    func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //refresh layout
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.cueView.collectionViewLayout.invalidateLayout()
    }
}
