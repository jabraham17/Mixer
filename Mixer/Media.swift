//
//  Media.swift
//  Mixer
//
//  Created by Jacob R. Abraham on 9/27/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import Foundation

//class to hold media files
class Media {
    
    var file: URL
    
    //default init
    init() {
        file = URL(fileURLWithPath: "")
    }
    
    //init
    init(file: URL) {
        self.file = file
    }
}
