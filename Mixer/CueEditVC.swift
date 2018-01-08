//
//  CueEditVC.swift
//  Mixer
//
//  Created by Jacob R. Abraham on 1/7/18.
//  Copyright © 2018 Jacob R. Abraham. All rights reserved.
//

import UIKit

//protocol/delegate that view controller class will acknolege
protocol CueEditDelegate: class {
    //called when popup is closed, will be implemented in view controller acknolwding this protocol/delegate
    func closed(cue: GenericCue)
}
