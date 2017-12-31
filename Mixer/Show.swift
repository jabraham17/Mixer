//
//  Show.swift
//  Mixer
//
//  Created by Jacob R. Abraham on 9/22/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import Foundation

//data structure for show
class Show: Codable {
    
    //entries
    var listing: [GenericCue]
    var name: String
    //TODO: update these as things change
    let dateCreated: Date
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
    
    
    
    //encoding
    private enum CodingKeys: String, CodingKey {
        case listing = "cueListing"
        case name
        case dateCreated
        case dateLastRun
        case dateLastEdit
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(listing, forKey: .listing)
        try container.encode(name, forKey: .name)
        try container.encode(dateCreated, forKey: .dateCreated)
        try container.encode(dateLastRun, forKey: .dateLastRun)
        try container.encode(dateLastEdit, forKey: .dateLastEdit)
    }
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        listing = try values.decode(Array.self, forKey: .listing)
        name = try values.decode(String.self, forKey: .name)
        dateCreated = try values.decode(Date.self, forKey: .dateCreated)
        dateLastRun = try values.decode(Date?.self, forKey: .dateLastRun)
        dateLastEdit = try values.decode(Date.self, forKey: .dateLastEdit)
    }
}

