//
//  CoursesViewController.swift
//  Golf Score Card
//
//  Created by Scott Bennett on 10/31/18.
//  Copyright © 2018 Scott Bennett. All rights reserved.
//

import UIKit
import Firebase

class CoursesViewController: UIViewController {
    
    
    @IBOutlet weak var courseNameTextField: UITextField!
    
    // Used Outlet Containers
    @IBOutlet var holeLabels: [UILabel]!
    @IBOutlet var parTextFields: [UITextField]!
    @IBOutlet var handicapTextFields: [UITextField]!
    @IBOutlet var yardageTextFields: [UITextField]!
    @IBOutlet weak var switchSidesLabel: UIButton!
    
    // MARK: - Properties
    
    var side = "front"
    var ref: DatabaseReference!
    var courses = [Course]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference(withPath: "courses")
        testCourse()
    }
    
    
    @IBAction func switchSides(_ sender: Any) {
        testCourse()
    }
    
    @IBAction func saveButton(_ sender: Any) {
        
        guard let courseName = courseNameTextField.text else { return }
        
        if side == "front" {
            
            let course = ["name" : courseName]
            let par = ["1" : parTextFields[0].text,
                       "2" : parTextFields[1].text,
                       "3" : parTextFields[2].text,
                       "4" : parTextFields[3].text,
                       "5" : parTextFields[4].text,
                       "6" : parTextFields[5].text,
                       "7" : parTextFields[6].text,
                       "8" : parTextFields[7].text,
                       "9" : parTextFields[8].text]
            
            let handicap = ["1" : handicapTextFields[0].text,
                            "2" : handicapTextFields[1].text,
                            "3" : handicapTextFields[2].text,
                            "4" : handicapTextFields[3].text,
                            "5" : handicapTextFields[4].text,
                            "6" : handicapTextFields[5].text,
                            "7" : handicapTextFields[6].text,
                            "8" : handicapTextFields[7].text,
                            "9" : handicapTextFields[8].text]
            
            let yardage = ["1" : yardageTextFields[0].text,
                           "2" : yardageTextFields[1].text,
                           "3" : yardageTextFields[2].text,
                           "4" : yardageTextFields[3].text,
                           "5" : yardageTextFields[4].text,
                           "6" : yardageTextFields[5].text,
                           "7" : yardageTextFields[6].text,
                           "8" : yardageTextFields[7].text,
                           "9" : yardageTextFields[8].text]
            
            ref?.child(courseName.lowercased()).setValue(course)
            ref?.child(courseName.lowercased()).child("par").setValue(par)
            ref?.child(courseName.lowercased()).child("handicap").setValue(handicap)
            ref?.child(courseName.lowercased()).child("yardage").setValue(yardage)
            
        } else {
            
            let course = ["name" : courseName]
            let par = ["10" : parTextFields[0].text,
                       "11" : parTextFields[1].text,
                       "12" : parTextFields[2].text,
                       "13" : parTextFields[3].text,
                       "14" : parTextFields[4].text,
                       "15" : parTextFields[5].text,
                       "16" : parTextFields[6].text,
                       "17" : parTextFields[7].text,
                       "18" : parTextFields[8].text]
            
            let handicap = ["10" : handicapTextFields[0].text,
                            "11" : handicapTextFields[1].text,
                            "12" : handicapTextFields[2].text,
                            "13" : handicapTextFields[3].text,
                            "14" : handicapTextFields[4].text,
                            "15" : handicapTextFields[5].text,
                            "16" : handicapTextFields[6].text,
                            "17" : handicapTextFields[7].text,
                            "18" : handicapTextFields[8].text]
            
            let yardage = ["10" : yardageTextFields[0].text,
                           "11" : yardageTextFields[1].text,
                           "12" : yardageTextFields[2].text,
                           "13" : yardageTextFields[3].text,
                           "14" : yardageTextFields[4].text,
                           "15" : yardageTextFields[5].text,
                           "16" : yardageTextFields[6].text,
                           "17" : yardageTextFields[7].text,
                           "18" : yardageTextFields[8].text]
            
            ref?.child(courseName.lowercased()).setValue(course)
            ref?.child(courseName.lowercased()).child("par").setValue(par)
            ref?.child(courseName.lowercased()).child("handicap").setValue(handicap)
            ref?.child(courseName.lowercased()).child("yardage").setValue(yardage)
            
        }
        
        self.view.endEditing(true)
    }

}

// MARK: - Test Data

extension CoursesViewController {
    
    func testCourse() {
        
        if side == "front" {
            courseNameTextField.text = "Pioneer Front"
            
            holeLabels[0].text = "10"
            holeLabels[1].text = "11"
            holeLabels[2].text = "12"
            holeLabels[3].text = "13"
            holeLabels[4].text = "14"
            holeLabels[5].text = "15"
            holeLabels[6].text = "16"
            holeLabels[7].text = "17"
            holeLabels[8].text = "18"
            
            parTextFields[0].text = "4"
            parTextFields[1].text = "4"
            parTextFields[2].text = "4"
            parTextFields[3].text = "3"
            parTextFields[4].text = "4"
            parTextFields[5].text = "4"
            parTextFields[6].text = "4"
            parTextFields[7].text = "5"
            parTextFields[8].text = "4"
            
            handicapTextFields[0].text = "18"
            handicapTextFields[1].text = "14"
            handicapTextFields[2].text = "12"
            handicapTextFields[3].text = "6"
            handicapTextFields[4].text = "8"
            handicapTextFields[5].text = "4"
            handicapTextFields[6].text = "2"
            handicapTextFields[7].text = "10"
            handicapTextFields[8].text = "16"
            
            yardageTextFields[0].text = "263"
            yardageTextFields[1].text = "314"
            yardageTextFields[2].text = "328"
            yardageTextFields[3].text = "172"
            yardageTextFields[4].text = "366"
            yardageTextFields[5].text = "371"
            yardageTextFields[6].text = "426"
            yardageTextFields[7].text = "455"
            yardageTextFields[8].text = "302"
            
            switchSidesLabel.setTitle("GoTo Front 9", for: .normal)
            side = "back"
        } else {
            courseNameTextField.text = "Pioneer Back"
            
            holeLabels[0].text = "1"
            holeLabels[1].text = "2"
            holeLabels[2].text = "3"
            holeLabels[3].text = "4"
            holeLabels[4].text = "5"
            holeLabels[5].text = "6"
            holeLabels[6].text = "7"
            holeLabels[7].text = "8"
            holeLabels[8].text = "9"
            
            parTextFields[0].text = "4"
            parTextFields[1].text = "4"
            parTextFields[2].text = "3"
            parTextFields[3].text = "4"
            parTextFields[4].text = "3"
            parTextFields[5].text = "4"
            parTextFields[6].text = "4"
            parTextFields[7].text = "4"
            parTextFields[8].text = "5"
            
            handicapTextFields[0].text = "9"
            handicapTextFields[1].text = "5"
            handicapTextFields[2].text = "3"
            handicapTextFields[3].text = "7"
            handicapTextFields[4].text = "17"
            handicapTextFields[5].text = "11"
            handicapTextFields[6].text = "13"
            handicapTextFields[7].text = "15"
            handicapTextFields[8].text = "1"
            
            yardageTextFields[0].text = "292"
            yardageTextFields[1].text = "396"
            yardageTextFields[2].text = "178"
            yardageTextFields[3].text = "335"
            yardageTextFields[4].text = "156"
            yardageTextFields[5].text = "293"
            yardageTextFields[6].text = "274"
            yardageTextFields[7].text = "269"
            yardageTextFields[8].text = "513"
            
            switchSidesLabel.setTitle("GoTo Back 9", for: .normal)
            side = "front"
        }
    }
}
