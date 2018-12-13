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
    @IBOutlet weak var addPlayerButton: UIButton!
    
    // MARK: - Properties
    
    var playerRef: DatabaseReference!
    var players = [Player]()

    override func viewDidLoad() {
        super.viewDidLoad()

        playerTableView.layer.cornerRadius = 10
        
        playerRef = Database.database().reference(withPath: "players")
        
        retrievePlayers()
        
        
       
    }
    
    @IBAction func addPlayer(_ sender: Any) {
        
        updatePlayer()
        
        playerName.text = ""
        playerHandicap.text = ""
        
        self.view.endEditing(true)
        addPlayerButton.setTitle("Add Player", for: .normal)
        
        
    }
    
    func updatePlayer() {
        
        guard let name = playerName.text,
            let handicap = playerHandicap.text else { return }
        let status = ""
        let player = ["name" : name, "handicap" : handicap, "status" : status]
        
        playerRef?.child(name.lowercased()).setValue(player)
        self.playerTableView.reloadData()
    }
    
    func retrievePlayers() {
      
        let playerDB = Database.database().reference().child("players")

        playerDB.observe(.childAdded) { (snapshot) in
      
            let value = snapshot.value as? NSDictionary
            let name = value?["name"] as? String ?? ""
            let handicap = value?["handicap"] as? String ?? ""
            let status = value?["status"] as? String ?? "out"
            
            let player = Player()
            player.name = name
            player.handicap = handicap
            player.status = status
            
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
        cell.detailTextLabel?.text = "Handicap: \(players[indexPath.row].handicap)"
        if players[indexPath.row].status == "out" {
           cell.accessoryType = .none
        } else {
            cell.accessoryType = .checkmark
        }
        
    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            players[indexPath.row].status = "out"
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            players[indexPath.row].status = "in"
        }
        
        playerName.text = players[indexPath.row].name
        playerHandicap.text = players[indexPath.row].handicap
        addPlayerButton.setTitle("Update Player", for: .normal)
    }
    


}
