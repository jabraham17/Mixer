//
//  DataManager.swift
//  Mixer
//
//  Created by Jacob R. Abraham on 12/29/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import Foundation
import Regex

//FEAT: make each show a seperate file with a plist containg all the files
//data management class, singleton
class DataManager {
    
    static let instance = DataManager()
    
    
    //get the file path of the data
    class func getPath() -> String {
        //get the path
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let path = documents + "/Shows.dat"
        return path
    }
    
    //init, read in data from file, if exist
    //if it doesnt, create the file
    init() {
        
        let path = DataManager.getPath()
        
        //if the file at the path does not exist, create it
        if !FileManager.default.fileExists(atPath: path) {
            //attributes is owner, can use default
            //make with no data as file does not exist
            FileManager.default.createFile(atPath: path, contents: nil, attributes: nil)
            log.verbose("Succesfully created file")
            //since file did not exit, init shows to be empty
            shows = []
        }
        else {
            //init the shows
            shows = []
            //if the file exists, read in the data
            do {
                let raw = FileManager.default.contents(atPath: path)
                //conditionally read in the data as a string
                guard let string = String(data: raw!, encoding: .utf8) else { throw Global.ParseError.ParseError(message: "No valid data found in file at path '\(path)'") }
                log.verbose("Full text of save file: \(string)")
                
                //regex to get all shows
                let regex = "\\{(ShowName.*?\\])\\}"
                let matchs = regex.r!.findAll(in: string)
                for match in matchs {
                    
                    log.verbose("Match found: \(match.group(at: 1)!)")
                    //get the next show
                    let nextShow = try Show(decodeWith: match.group(at: 1)!)
                    log.verbose("Match parsed as show: \(nextShow)")
                    //add the show to the list
                    shows.append(nextShow)
                }
                
                log.verbose("Succesfully read file")
            }
            catch {
                log.warning("Error decoding Shows array: \(error)")
                //FEAT: make attempts to recover data instead of deleeting
                try! FileManager.default.removeItem(atPath: path)
                log.verbose("Removed file")
            }
        }
        
    }
    
    //save all data
    func save() {
        //encode shows
        let encoded = DataManager.instance.shows.reduce("[") {result, next in
            return "\(result){\(next.encode())}"
            } + "]"
        let raw = encoded.data(using: .utf8)!
            
        //write it to file
        FileManager.default.createFile(atPath: DataManager.getPath(), contents: raw, attributes: nil)
        log.verbose("Succesfully saved to file")
    }
    
    //all data
    var shows: [Show]
    
    
    
}
