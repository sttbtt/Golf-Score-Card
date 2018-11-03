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
    
    var playerRef: DatabaseReference!
    var players = [Player]()

    override func viewDidLoad() {
        super.viewDidLoad()

        playerRef = Database.database().reference(withPath: "players")
        
        retrievePlayers()
       
    }
    
    @IBAction func addPlayer(_ sender: Any) {
        guard let name = playerName.text,
            let handicap = playerHandicap.text else { return }
        
        let player = ["name" : name, "handicap" : handicap]
        
        playerRef?.child(name.lowercased()).setValue(player)
        
        playerName.text = ""
        playerHandicap.text = ""
        
        self.view.endEditing(true)
        
    }
    
    func retrievePlayers() {
      
        let playerDB = Database.database().reference().child("players")

        playerDB.observe(.childAdded) { (snapshot) in
      
            let value = snapshot.value as? NSDictionary
            let name = value?["name"] as? String ?? ""
            let handicap = value?["handicap"] as? String ?? ""

            let player = Player()
            player.name = name
            player.handicap = handicap
            
            self.players.append(player)
            
            DispatchQueue.main.async { self.playerTableView.reloadData() }
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            
            let player = players[indexPath.row].name
            
            players.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            
            playerRef.child(player.lowercased()).removeValue()
        }
    }
    


}
