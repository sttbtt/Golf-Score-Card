//
//  ScoringViewController.swift
//  Golf Score Card
//
//  Created by Scott Bennett on 10/28/18.
//  Copyright © 2018 Scott Bennett. All rights reserved.
//

import UIKit

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
    
    let addPlayerViewController = AddPlayerViewController()
    
    
    let strokes = [["1", "2", "3", "4", "5", "6", "7", "8", "9"]]
    var strokeSelected: String = ""

    
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
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !addPlayerViewController.players.isEmpty {
            
            self.player1Name.text = addPlayerViewController.players[0].name
            self.player2Name.text = addPlayerViewController.players[1].name
            self.player3Name.text = addPlayerViewController.players[2].name
            self.player4Name.text = addPlayerViewController.players[3].name
        }
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
