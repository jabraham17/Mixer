//
//  Show.swift
//  Mixer
//
//  Created by Jacob R. Abraham on 9/22/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import Foundation
import Regex

//data structure for show
class Show: Serializable, CustomStringConvertible {
    
    //entries
    var listing: [GenericCue] {
        //if an update occurs, update the last edit date
        didSet {
            self.dateLastEdit = Date()
        }
    }
    var name: String {
        //if an update occurs, update the last edit date
        didSet {
            self.dateLastEdit = Date()
        }
    }
    let dateCreated: Date
    var dateLastRun: Date?
    var dateLastEdit: Date
    
    //when the show runs, call this s that last run uodates
    func run() {
        dateLastRun = Date()
    }
    
    //default init
    init() {
        self.listing = []
        self.name = "New Show"
        let currentDate = Date()
        self.dateCreated = currentDate
        self.dateLastRun = nil
        self.dateLastEdit = currentDate
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
    
    func encode() -> String {
        let cueStr = listing.reduce("") {result, next in "\(result){\(next.encode())}"}
        let encoded = "ShowName:<\(name)>,DateCreated:<\(dateCreated.timeIntervalSince1970)>,DateLastEdit:<\(dateLastEdit.timeIntervalSince1970)>,DateLastRun:<\(dateLastRun?.timeIntervalSince1970 ?? 0)>,CueListing:[\(cueStr)]"
        return encoded
    }
    required init(decodeWith string: String) throws {
        //regexs to get the different fields
        let regex = "ShowName:<([^<>]*)>,DateCreated:<([\\d\\.]*)>,DateLastEdit:<([\\d\\.]*)>,DateLastRun:<((?:nil)|(?:[\\d\\.]*))>,CueListing:\\[(.*)\\]"
        let match = regex.r!.findFirst(in: string)
        //check if it matches, if it doesnt, throw an error
        if match == nil {
            throw Global.ParseError.ParseError(message: "The input '\(string)' does not match regex '\(regex)'")
        }
        //if it matches, get all of the variables and load each variable
        name = match!.group(at: 1)!
        dateCreated = Date(timeIntervalSince1970: Double(match!.group(at: 2)!)!)
        dateLastEdit = Date(timeIntervalSince1970: Double(match!.group(at: 3)!)!)
        let group4 = match!.group(at: 4)!
        dateLastRun = group4 == "nil" ? nil : Date(timeIntervalSince1970: Double(group4)!)
        
        //init the listing
        listing = []
        
        //regex to get cue fields inside of group 5
        let cueRegex = "\\{(Cue[^\\{\\{]*)|(Transition[^\\{\\{]*)|(Generic[^\\{\\{]*)\\}"
        let cueMatchs = cueRegex.r!.findAll(in: match!.group(at: 5)!)
        for cueMatch in cueMatchs {
            //if its a cue, this will have the value
            let cue = cueMatch.group(at: 1)
            let trans = cueMatch.group(at: 2)
            let generic = cueMatch.group(at: 3)
            
            //if its a generic, throw an error
            if generic != nil {
                throw Global.ParseError.ParseError(message: "Cannot read GenericCue values")
            }
            //if its a cue, call the Cue parser and add it to the list
            else if cue != nil {
                listing.append(try Cue(decodeWith: cue!))
            }
            //if its a transition, call the Transition parser and add it to the list
            else if trans != nil {
                listing.append(try Transition(decodeWith: trans!))
            }
        }
        
    }
    
    var description: String {
        let mainLine = "Show named '\(name)', created on '\(dateCreated)', edited on '\(dateLastEdit)', last run on '\(dateLastRun == nil ? "never run" : dateLastRun!.description)'"
        let cues = listing.reduce("") {result, nextCue in
            return "\(result)\n\t\(nextCue)"
        }
        return "\(mainLine)\nCues:\(cues)"
    }
}
