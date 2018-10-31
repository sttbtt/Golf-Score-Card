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

    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference(withPath: "players")
        
       
    }
    
    @IBAction func addPlayer(_ sender: Any) {
        guard let name = playerName.text,
            let handicap = playerHandicap.text else { return }
        
        let player = ["name" : name, "handicap" : handicap]
        
        ref?.child(name.lowercased()).setValue(player)

        playerName.text = ""
        playerHandicap.text = ""
        
    }
    


}
