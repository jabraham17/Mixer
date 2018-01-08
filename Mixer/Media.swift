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
    
    var mediaItem: MPMediaItem?
    
    //default init
    init() {
        mediaItem = nil
    }
    
    //init
    init(item: MPMediaItem) {
        self.mediaItem = item
    }
    
    //make a media item from an id
    class func initWith(_ id: String) -> Media {
        
        //if no id, ie is 0, return a blank media
        if id == "0" {
            return Media()
        }
        else {
            //search through user library
            let query = MPMediaQuery.songs()
            query.addFilterPredicate(MPMediaPropertyPredicate(value: id, forProperty: MPMediaItemPropertyPersistentID))
            let media = Media(item: query.items!.first!)
            return media
        }
    }
    
    //formatted name
    func getFormattedName() -> String {
        
        //if no media item, return "No Media"
        if mediaItem == nil {
            return "No Media"
        }
        else {
            return "\(mediaItem!.artist ?? "Unknown Artist") - \(mediaItem!.title ?? "Unknown Title")"
        }
    }
    func getID() -> MPMediaEntityPersistentID {
        //if no media item, return 0
        if mediaItem == nil {
            return 0
        }
        else {
            return mediaItem!.persistentID
        }

    }
}
