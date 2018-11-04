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
    
    @IBOutlet weak var player1ScoreLabel: UILabel!
    @IBOutlet weak var player2ScoreLabel: UILabel!
    @IBOutlet weak var player3ScoreLabel: UILabel!
    @IBOutlet weak var player4ScoreLabel: UILabel!
    
    @IBOutlet weak var holeNumber: UILabel!
    
    @IBOutlet weak var player1PickerView: UIPickerView!
    @IBOutlet weak var player2PickerView: UIPickerView!
    @IBOutlet weak var player3PickerView: UIPickerView!
    @IBOutlet weak var player4PickerView: UIPickerView!
    @IBOutlet weak var nextHoleLabel: UIButton!
    @IBOutlet weak var previousHoleLabel: UIButton!
    
    // MARK: - Properties
    
    var strokeSelected: String = ""
    
    var player1Strokes = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    var player2Strokes = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    var player3Strokes = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    var player4Strokes = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    
    var currentHole = 1
    
    var player1Score = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    var player2Score = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    var player3Score = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    var player4Score = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    
    var player1Par = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    var player2Par = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    var player3Par = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    var player4Par = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    
    var player1Row = 4
    var player2Row = 4
    var player3Row = 4
    var player4Row = 4
    
    let coursePar = [4, 4, 3, 4, 3, 4, 4, 4, 5, 4, 4, 4, 3, 4, 4, 4, 5, 4]
    
    var scoreType = true
    
    
    // Mark: - References
    
    var ref: DatabaseReference!
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
        
        previousHoleLabel.transform = CGAffineTransform(scaleX: -1, y: 1)
    }

    
    @IBAction func nextHole(_ sender: Any) {
        if currentHole < 18 {
            currentHole += 1
            holeNumber.text = "HOLE \(currentHole)"
            updateLabels()
        }
    }
    
    @IBAction func previousHole(_ sender: Any) {
        if currentHole > 1 {
            currentHole -= 1
            holeNumber.text = "HOLE \(currentHole)"
            updateLabels()
        }
    }
    
    func fetchPlayers() {
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
                self.updateLabels()
            }
        }
       
    }
    
    func updateLabels() {
        
        player1Name.text = players[0].name
        player2Name.text = players[1].name
        player3Name.text = players[2].name
        player4Name.text = players[3].name
        
        player1ScoreLabel.text = (scoreType ? String(player1Score.reduce(0, +)) : String(player1Par.reduce(0, +)))
        player2ScoreLabel.text = (scoreType ? String(player2Score.reduce(0, +)) : String(player2Par.reduce(0, +)))
        player3ScoreLabel.text = (scoreType ? String(player3Score.reduce(0, +)) : String(player3Par.reduce(0, +)))
        player4ScoreLabel.text = (scoreType ? String(player4Score.reduce(0, +)) : String(player4Par.reduce(0, +)))
        
        player1PickerView.selectRow(player1Score[currentHole - 1], inComponent: 0, animated: true)
        player2PickerView.selectRow(player2Score[currentHole - 1], inComponent: 0, animated: true)
        player3PickerView.selectRow(player3Score[currentHole - 1], inComponent: 0, animated: true)
        player4PickerView.selectRow(player4Score[currentHole - 1], inComponent: 0, animated: true)
    }
    
    // MARK: - PickerView
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == player1PickerView {
            return player1Strokes.count
        } else if pickerView == player2PickerView {
            return player2Strokes.count
        }else if pickerView == player3PickerView {
            return player3Strokes.count
        } else {
            return player4Strokes.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == player1PickerView {
            return player1Strokes[row]
        } else if pickerView == player2PickerView {
            return player2Strokes[row]
        }else if pickerView == player3PickerView {
            return player3Strokes[row]
        } else {
            return player4Strokes[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == player1PickerView {
            player1Score[currentHole - 1] = Int(player1Strokes[row])!
            player1Par[currentHole - 1] = Int(player1Strokes[row])! - coursePar[currentHole - 1]
        } else if pickerView == player2PickerView {
            player2Score[currentHole - 1] = Int(player2Strokes[row])!
            player2Par[currentHole - 1] = Int(player2Strokes[row])! - coursePar[currentHole - 1]
        } else if pickerView == player3PickerView {
            player3Score[currentHole - 1] = Int(player3Strokes[row])!
            player3Par[currentHole - 1] = Int(player3Strokes[row])! - coursePar[currentHole - 1]
        } else {
            player4Score[currentHole - 1] = Int(player4Strokes[row])!
            player4Par[currentHole - 1] = Int(player4Strokes[row])! - coursePar[currentHole - 1]
        }
    }
    

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBAction func totalParSelector(_ sender: Any) {
        
        // TODO: - Switch between total and over par scoring
        
        switch  segmentedControl.selectedSegmentIndex {
        case 0:
            scoreType = true
        case 1:
            scoreType = false
        default:
            break
        }
        
        updateLabels()
    }
    
    // TODO: - Design landscape layout

    // MARK: - Rotation
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        print(UIDevice.current.orientation.isLandscape)
        
        
    }

}
