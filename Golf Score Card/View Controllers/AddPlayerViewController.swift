//
//  AddPlayerViewController.swift
//  Golf Score Card
//
//  Created by Scott Bennett on 10/29/18.
//  Copyright © 2018 Scott Bennett. All rights reserved.
//

import UIKit
import FirebaseDatabase

class AddPlayerViewController: UIViewController {
    
    @IBOutlet weak var playerName: UITextField!
    @IBOutlet weak var playerHandicap: UITextField!
    
    var players = [Player]()
    weak var delegate: ScoringViewController!
    
    var ref: DatabaseReference?
    var databaseHandle: DatabaseHandle?

    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
    }
    
    @IBAction func addPlayer(_ sender: Any) {
        guard let name = playerName.text,
            let handicap = playerHandicap.text else { return }
        
        let player = Player(name: name, handicap: handicap)
        
        ref?.child("Players").setValue(playerName.text)
        ref?.child("Players").child(playerName.text!).child("Handicap").setValue(playerHandicap.text)
        players.append(player)
        
        playerName.text = ""
        playerHandicap.text = ""
        
        print(players)
        print(players.isEmpty)
    }
    


}
