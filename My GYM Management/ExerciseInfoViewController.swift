//
//  ExerciseInfoViewController.swift
//  My GYM Management
//
//  Created by Aaron Granado Amores on 11/4/20.
//  Copyright © 2020 AlphaDvlpr. All rights reserved.
//

import UIKit

class ExerciseInfoViewController: UIViewController {

    //MARK: UI elements connection
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var executionLabel: UILabel!
    @IBOutlet weak var musclesLabel: UILabel!
    @IBOutlet weak var openLinkOutlet: UIButton!
    @IBOutlet weak var editButtonOutlet: UIBarButtonItem!
    
    //MARK: Variables and constants
    var localExercise: Exercise!
    
    //MARK: Main function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
    }
    
    //MARK: IBActions
    @IBAction func openLinkButtonPressed(_ sender: UIButton) {
        if let linkURL = URL(string: localExercise.link ?? "https://www.google.es") {
            UIApplication.shared.open(linkURL)
        }
    }
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        print("edit button pressed")
    }
    
    @IBAction func sendButtonPressed(_ sender: UIBarButtonItem) {
        print("send button pressed")
    }
    
    //MARK: Update UI
    func updateUI() {
        if localExercise != nil {
            self.title = localExercise.name?.uppercased()
            
            infoLabel.text = localExercise.info
            executionLabel.text = localExercise.execution
            musclesLabel.text = localExercise.muscles == nil ? "No hay músculos" : localExercise.muscles
            
            if localExercise.link != nil {
                openLinkOutlet.setTitle("Abrir", for: .normal)
                openLinkOutlet.isEnabled = true
            } else {
                openLinkOutlet.setTitle("N/D", for: .disabled)
                openLinkOutlet.isEnabled = false
                openLinkOutlet.setTitleColor(UIColor.gray, for: .disabled)
            }
            
            editButtonOutlet.isEnabled = localExercise.isUserCreated
            
        } else {
            self.title = "ERROR"
        }
    }
}
