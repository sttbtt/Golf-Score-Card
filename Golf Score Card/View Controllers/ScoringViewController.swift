//
//  ScoringViewController.swift
//  Golf Score Card
//
//  Created by Scott Bennett on 10/28/18.
//  Copyright © 2018 Scott Bennett. All rights reserved.
//

import UIKit
import Firebase

class ScoringViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var player1Name: UILabel!
    @IBOutlet weak var player2Name: UILabel!
    @IBOutlet weak var player3Name: UILabel!
    @IBOutlet weak var player4Name: UILabel!
    
    @IBOutlet weak var holeNumber: UILabel!
    
    @IBOutlet weak var player1PickerView: UIPickerView!
    @IBOutlet weak var player2PickerView: UIPickerView!
    @IBOutlet weak var player3PickerView: UIPickerView!
    @IBOutlet weak var player4PickerView: UIPickerView!
    
    // MARK: - Properties
    
    let strokes = [["1", "2", "3", "4", "5", "6", "7", "8", "9"]]
    var strokeSelected: String = ""
    var players: [Player] = [Player]()
    var ref: DatabaseReference!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.player1PickerView.delegate = self
        self.player1PickerView.dataSource = self
        self.player2PickerView.delegate = self
        self.player2PickerView.dataSource = self
        self.player3PickerView.delegate = self
        self.player3PickerView.dataSource = self
        self.player4PickerView.delegate = self
        self.player4PickerView.dataSource = self
        

//        ref = Database.database().reference(withPath: "players")
//
//        ref.observe(.value, with: { snapshot in
//            var players: [Player] = []
//            for player in snapshot.children {
//                let player = Player(snapshot: player as! DataSnapshot)
//                //players.append(player!)
//                print(player)
//            }
//        })
//
//        ref.child("scott").observe(.value) { (snapshot) in
//            let values = snapshot.value as! [String: AnyObject]
//            let name = values["name"] as! String
//            let handicap = values["handicap"] as! String
//
//            print("name: \(name)")
//            print("handicap: \(handicap)")
//
//            self.player1Name.text = name
//        }
        
        fetchPlayers()
        
    }
    
    @IBAction func nextHole(_ sender: Any) {
    }
    
    
    @IBAction func previousHole(_ sender: Any) {
    }
    
    func fetchPlayers() {
        let playerDB = Database.database().reference().child("players")
        
        playerDB.observe(.childAdded) { (snapshot) in
            
            let snapshotValue = snapshot.value as! Dictionary<String, String>
            
            let name = snapshotValue["name"]!
            let handicap = snapshotValue["handicap"]!
            
            var player = Player()
            player.name = name
            player.handicap = handicap
            
            self.players.append(player)
        }
        
        print(players)
        
//        player1Name.text = players[0].name
//        player1Name.text = players[1].name
//        player1Name.text = players[2].name
//        player1Name.text = players[3].name
    }
    
    // MARK: - PickerView
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return strokes[0].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return strokes[component][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        strokeSelected = strokes[0][row]
        
    }
    
    // MARK: - Rotation
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        print(UIDevice.current.orientation.isLandscape)
        
        
    }

}
