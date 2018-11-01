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
    var currentHole = 1
    
    // Mark: - References
    
    var ref: DatabaseReference!
//    let addPlayerVC = AddPlayerViewController()
    var players = [Player]()
    
    
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

        
        fetchPlayers()
        let score = player1PickerView.value(forKey: strokes)
        print(score)
        
    }
    
    @IBAction func nextHole(_ sender: Any) {
        if currentHole < 18 {
            currentHole += 1
            holeNumber.text = "Hole # \(currentHole)"
        }
        
    }
    
    
    @IBAction func previousHole(_ sender: Any) {
        if currentHole > 1 {
            currentHole -= 1
            holeNumber.text = "Hole # \(currentHole)"
        }
        
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
        
        player1Name.text = "John"
        player2Name.text = "Paul"
        player3Name.text = "Ringo"
        player4Name.text = "George"
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
