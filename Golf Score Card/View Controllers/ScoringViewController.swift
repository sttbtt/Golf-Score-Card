//
//  ScoringViewController.swift
//  Golf Score Card
//
//  Created by Scott Bennett on 10/28/18.
//  Copyright © 2018 Scott Bennett. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import HealthKit

class ScoringViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, MKMapViewDelegate, CLLocationManagerDelegate {
    
    // MARK: - Properties
    
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
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var stepsLabel: UILabel!
    
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
    
//    let newPin = MKPointAnnotation()
    
    
    // Mark: - References
    
    let healthKitManager = HealthKitManager()
    var roundRef: DatabaseReference!
    var players = [Player]()
    
    var locationManager = CLLocationManager()
    private var userTrackingButton = MKUserTrackingButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        healthKitManager.authorizeHealthKit()
        
        roundRef = Database.database().reference(withPath: "rounds")
        
        self.player1PickerView.delegate = self
        self.player1PickerView.dataSource = self
        self.player2PickerView.delegate = self
        self.player2PickerView.dataSource = self
        self.player3PickerView.delegate = self
        self.player3PickerView.dataSource = self
        self.player4PickerView.delegate = self
        self.player4PickerView.dataSource = self

        fetchPlayers()
        fetchScores()
        
        previousHoleLabel.transform = CGAffineTransform(scaleX: -1, y: 1)
        
        mapView.showsUserLocation = true
        if CLLocationManager.locationServicesEnabled() == true {
            
            if CLLocationManager.authorizationStatus() == .restricted || CLLocationManager.authorizationStatus() == .denied ||  CLLocationManager.authorizationStatus() == .notDetermined {
                locationManager.requestWhenInUseAuthorization()
            }
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        } else {
            print("PLease turn on location services or GPS")
        }
    }


    
    @IBAction func nextHole(_ sender: Any) {
        if currentHole < 18 {
            currentHole += 1
            holeNumber.text = "HOLE \(currentHole)"
            updateLabels()
            updateScores()
        }
    }
    
    @IBAction func previousHole(_ sender: Any) {
        if currentHole > 1 {
            currentHole -= 1
            holeNumber.text = "HOLE \(currentHole)"
            updateLabels()
            updateScores()
        }
    }
    
    func fetchPlayers() {
        let playerDB = Database.database().reference().child("players")
        
        playerDB.observe(.childAdded) { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            let name = value?["name"] as? String ?? ""
            let handicap = value?["handicap"] as? String ?? ""
            
            let player = Player()
            player.name = name
            player.handicap = handicap
            
            self.players.append(player)
            
            DispatchQueue.main.async { self.updateLabels() }
        }
    }
    
    func fetchScores() {
        let roundsDB = Database.database().reference().child("rounds")
        
        roundsDB.observe(.childAdded) { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            let score = value?["hole1"] as? String ?? "0"
            
            
            self.player1Score.append(Int(score)!)
            
            DispatchQueue.main.async { self.updateLabels() }
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
    
    func updateScores() {
        
        let score1 = ["hole1" : String(player1Score[0])]
        
        roundRef.setValue(score1)
//        roundRef.child("current round").child(players[1].name).setValue(player2Score)
//        roundRef.child("current round").child(players[2].name).setValue(player3Score)
//        roundRef.child("current round").child(players[3].name).setValue(player4Score)
        
    }
    

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBAction func totalParSelector(_ sender: Any) {
        
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
    
    // MARK: - HealthKit
    
    @IBAction func getSteps(_ sender: Any) {
        
        healthKitManager.authorizeHealthKit()
        
        healthKitManager.getTodaysSteps { (result) in
            print("\(result)")
            let formatted = String(format: "%.0f", result)
            DispatchQueue.main.async {
                self.stepsLabel.text = "\(formatted)"
            }
        }
    }
    
}

// MARK: - Mapping

extension ScoringViewController {
    
    //MARK:- CLLocationManager Delegates  38.9679, -84.5844
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager.stopUpdatingLocation()
        
        let pioneerLocation = CLLocationCoordinate2D(latitude: 38.9679, longitude: -84.5844)
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
        
        let region = MKCoordinateRegion(center: pioneerLocation, span: span)
        
//         let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002))
        
        self.mapView.setRegion(region, animated: true)
        
        
//       newPin.coordinate = location.coordinate
//        mapView.addAnnotation(newPin)
        
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Unable to access your current location")
    }
    
//    func setUserLocationOnLowerPositiononMap(coordinate: CLLocationCoordinate2D) {
//        var region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//        region.center = coordinate
//        self.mapView.setRegion(region, animated: true)
//        self.map.moveCenterByOffSet(offSet: CGPoint(x: 0, y: -130), coordinate: coordinate)
//        //self.map.moveCenterByOffSet(offSet: CGPoint(x: 0, y: SCREEN_HEIGHT - SCREEN_HEIGHT * 4/3 + 0 ), coordinate: coordinate)
//    }
    
}

// MARK: - Test Data

extension ScoringViewController {
    
    @IBAction func loadTestScores(_ sender: Any) {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
        feedbackGenerator.impactOccurred()
        
        var player1TestScore = [Int]()
        var player2TestScore = [Int]()
        var player3TestScore = [Int]()
        var player4TestScore = [Int]()
        
        var player1TestPar = [Int]()
        var player2TestPar = [Int]()
        var player3TestPar = [Int]()
        var player4TestPar = [Int]()
        
        for hole in 0...17 {
            let score1 = Int.random(in: (coursePar[hole] - 2)...(coursePar[hole] + 3))
            player1TestScore.append(score1)
            player1TestPar.append(score1 - coursePar[hole])
            let score2 = Int.random(in: (coursePar[hole] - 2)...(coursePar[hole] + 3))
            player2TestScore.append(score2)
            player2TestPar.append(score2 - coursePar[hole])
            let score3 = Int.random(in: (coursePar[hole] - 2)...(coursePar[hole] + 3))
            player3TestScore.append(score3)
            player3TestPar.append(score3 - coursePar[hole])
            let score4 = Int.random(in: (coursePar[hole] - 2)...(coursePar[hole] + 3))
            player4TestScore.append(score4)
            player4TestPar.append(score4 - coursePar[hole])
            
        }
        
        player1Score = player1TestScore
        player2Score = player2TestScore
        player3Score = player3TestScore
        player4Score = player4TestScore
        
        player1Par = player1TestPar
        player2Par = player2TestPar
        player3Par = player3TestPar
        player4Par = player4TestPar
        
        updateLabels()
    }
}
