//
//  DataManager.swift
//  Mixer
//
//  Created by Jacob R. Abraham on 12/29/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import Foundation


//data management class, singleton
class DataManager {
    
    static let instance = DataManager()
    
    
    //get the file path of the data
    class func getPath() -> String {
        //get the path
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let path = documents + "/Shows.json"
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
            print("Succesfully created file")
            //since file did not exit, init shows to be empty
            shows = []
        }
        else {
            //if the file exists, read in the data
            do {
                let raw = FileManager.default.contents(atPath: path)
                print(String.init(data: raw!, encoding: .utf8) ?? "")
                let decoder = JSONDecoder()
                //decode as show array
                shows = try decoder.decode([Show].self, from: raw!)
                for show in shows {
                    print(show)
                }
                print("Succesfully read file")
            }
            catch {
                print("Error decoding Shows array: \(error)")
                //FEAT: make attempts to recover data
                shows = []
                //TEMP: remove the file
                try! FileManager.default.removeItem(atPath: path)
            }
        }
        
    }
    
    //save all data
    func save() {
        do {
            let encoder = JSONEncoder()
            //get the raw data
            let raw = try encoder.encode(shows)
            //write it to file
            FileManager.default.createFile(atPath: DataManager.getPath(), contents: raw, attributes: nil)
            print("Succesfully saved to file")
        }
        catch {
            print("Error encoding Shows array: \(error)")
        }
    }
    
    //all data
    var shows: [Show]
    
    
    
}
