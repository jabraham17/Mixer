//
//  Show.swift
//  Mixer
//
//  Created by Jacob R. Abraham on 9/22/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import Foundation

//data structure for show
class Show {
    
    //entries
    var listing: [GenericCue]
    var name: String
    var dateCreated: Date
    var dateLastRun: Date?
    var dateLastEdit: Date
    
    //default init
    init() {
        self.listing = []
        self.name = "New Show"
        self.dateCreated = Date()
        self.dateLastRun = nil
        self.dateLastEdit = Date()
    }
    
    //init
    init(listing: [GenericCue], name: String, dateCreated: Date, dateLastRun: Date?, dateLastEdit: Date) {
        self.listing = listing
        self.name = name
        self.dateCreated = dateCreated
        self.dateLastRun = dateLastRun
        self.dateLastEdit = dateLastEdit
    }
    
    //add a new cue
    func add(cue: GenericCue) {
        listing.append(cue)
    }
    
}
