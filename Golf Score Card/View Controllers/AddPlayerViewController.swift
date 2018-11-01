//
//  AddPlayerViewController.swift
//  Golf Score Card
//
//  Created by Scott Bennett on 10/29/18.
//  Copyright © 2018 Scott Bennett. All rights reserved.
//

import UIKit
import Firebase

class AddPlayerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    
    @IBOutlet weak var playerName: UITextField!
    @IBOutlet weak var playerHandicap: UITextField!
    @IBOutlet weak var playerTableView: UITableView!
    
    // MARK: - Properties
    
    var ref: DatabaseReference!
    var players = [Player]()

    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference(withPath: "players")
        
        retrievePlayers()
       
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
        
    }
    
    func retrievePlayers() {
        let playerDB = Database.database().reference().child("players")
        
        playerDB.observe(.childAdded) { (snapshot) in
            
            let snapshotValue = snapshot.value as! Dictionary<String,String>
            
            let name = snapshotValue["name"]!
            let handicap = snapshotValue["handicap"]!
            
            let player = Player()
            player.name = name
            player.handicap = handicap
            
            self.players.append(player)
            
            DispatchQueue.main.async {
                self.playerTableView.reloadData()
            }
            
        }

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell", for: indexPath)
        
        cell.textLabel?.text = players[indexPath.row].name
        cell.detailTextLabel?.text = players[indexPath.row].handicap
    
        
        return cell
    }
    


}
