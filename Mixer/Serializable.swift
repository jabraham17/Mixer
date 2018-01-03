//
//  Serializable.swift
//  Mixer
//
//  Created by Jacob R. Abraham on 12/31/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import Foundation

//make things serialoable
protocol Serializable {
    //encode as a string
    func encode() -> String
    //decode using a string
    init(decodeWith string: String) throws
}
