//
//  AudioFader.swift
//  Mixer
//
//  Created by Jacob R. Abraham on 2/2/18.
//  Copyright © 2018 Jacob R. Abraham. All rights reserved.
//

import Foundation
import AVFoundation

class AudioFader {
    
    //number of times per second that the fade will update
    static var iterationsPerSecond: Int = 20
    static var timePerIteration: TimeInterval {
        return 1.0 / Double(iterationsPerSecond)
    }
    
    static var resuseTimer: Timer = Timer()
    
    //fade an audioplayer in async
    class func fadeIn(using player: AVAudioPlayer, over time: TimeInterval, from startVol: Double = 0.0, to endVol: Double = 1.0) {
        
        //number of steps it will take
        let numOfSteps = time * Double(iterationsPerSecond)
        //how much volume changes per step
        let sizeOfStep = endVol / numOfSteps
        
        //set the start volume
        player.volume = Float(startVol)
        
        var timesRun: Int = 0
        resuseTimer = Timer.scheduledTimer(withTimeInterval: timePerIteration, repeats: true, block: { (self) in
            
            //incrment the volume
            var currentVolume = player.volume
            currentVolume += Float(sizeOfStep)
            player.volume = currentVolume
            
            //incrmeent the countr
            timesRun += 1
            //if done, invalidate timer
            if timesRun >= Int(numOfSteps) {
                resuseTimer.invalidate()
            }
        })
        
        
    }
}
