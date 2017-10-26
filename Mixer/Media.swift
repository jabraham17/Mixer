//
//  Media.swift
//  Mixer
//
//  Created by Jacob R. Abraham on 9/27/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import Foundation
import MediaPlayer

//class to hold media files
class Media {
    
    var mediaItem: MPMediaItem
    
    //default init
    init() {
        mediaItem = MPMediaItem()
    }
    
    //init
    init(item: MPMediaItem) {
        self.mediaItem = item
    }
    
    //formatted name
    func getFormattedName() -> String {
        return "\(mediaItem.artist ?? "Unknown Artist") - \(mediaItem.title ?? "Unknown Title")"
    }
}
