//
//  Serializable.swift
//  Mixer
//
//  Created by Jacob R. Abraham on 12/31/17.
//  Copyright © 2017 Jacob R. Abraham. All rights reserved.
//

import Foundation

protocol Serializable {
    func encode() -> String
    init(decodeWith string: String) throws
}
