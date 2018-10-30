//
//  Player.swift
//  Golf Score Card
//
//  Created by Scott Bennett on 10/29/18.
//  Copyright © 2018 Scott Bennett. All rights reserved.
//

import Foundation

struct Player {
    let name: String
    let handicap: String
    
    init(name: String, handicap: String) {
        self.name = name
        self.handicap = handicap
    }
    
}
