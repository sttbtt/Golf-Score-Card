//
//  AddPlayerViewController.swift
//  Golf Score Card
//
//  Created by Scott Bennett on 10/29/18.
//  Copyright © 2018 Scott Bennett. All rights reserved.
//

import UIKit
import Firebase

class AddPlayerViewController: UIViewController {
    
    @IBOutlet weak var playerName: UITextField!
    @IBOutlet weak var playerHandicap: UITextField!
    
    // MARK: - Properties
    
    var ref: DatabaseReference!
    var players = [Player]()

    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference(withPath: "players")
        
       
    }
    
    @IBAction func addPlayer(_ sender: Any) {
        guard let name = playerName.text,
            let handicap = playerHandicap.text else { return }
        
        let playerZ = Player(name: name, handicap: handicap)
        let player = ["name" : name, "handicap" : handicap]
        
        ref?.child(name.lowercased()).setValue(player)
        
        players.append(playerZ)

        playerName.text = ""
        playerHandicap.text = ""
        
        self.view.endEditing(true)
        
        print(players)
        
    }
    


}
