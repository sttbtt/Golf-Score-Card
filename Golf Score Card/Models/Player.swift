//
//  Player.swift
//  Golf Score Card
//
//  Created by Scott Bennett on 10/29/18.
//  Copyright © 2018 Scott Bennett. All rights reserved.
//

import Foundation
import Firebase

class Player {
    var name: String
    var handicap: String
    var status: String
    
    init(name: String = " ", handicap: String = "0", status: String = "out") {
        self.name = name
        self.handicap = handicap
        self.status = status
    }
    
//    init?(snapshot: DataSnapshot) {
//        guard
//            let value = snapshot.value as? [String: AnyObject],
//            let name = value["name"] as? String,
//            let handicap = value["handicap"] as? Int else { return nil }
//        
//        self.ref = snapshot.ref
//        self.key = snapshot.key
//        self.name = name
//        self.handicap = handicap
//    }
    

    
}
