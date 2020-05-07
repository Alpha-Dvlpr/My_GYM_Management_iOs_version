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
    
    /**
     This method opens the link if the user has any application that can open it.
     
     - Parameter sender: The sender for the action (In this case UIButton).
     - Author: Aarón Granado Amores.
     */
    @IBAction func openLinkButtonPressed(_ sender: UIButton) {
        if let linkURL = URL(string: localExercise.link ?? "https://www.google.es") {
            UIApplication.shared.open(linkURL)
        }
    }
    
    /**
     This method sets the action for the edit exercise button.
     
     - Parameter sender: The sender for the action (In this case UIButton).
     - Author: Aarón Granado Amores.
     */
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        showInfoAlert(message: "Próximamente")
    }
    
    /**
     This method sets the action for the send exercise button.
     
     - Parameter sender: the sender or the action (In this case UIButton).
     - Author: Aarón Granado Amores.
     */
    @IBAction func sendButtonPressed(_ sender: UIBarButtonItem) {
        showInfoAlert(message: "Próximamente")
    }
    
    //MARK: AlertDialog
    
    /**
     This method show an Alert with the given message.
     
     - Parameter message: The message to be displayed.
     - Author: Aarón Granado Amores.
     */
    func showInfoAlert(message: String) {
        let infoAlert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        
        infoAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        self.present(infoAlert, animated: true, completion: nil)
    }
    
    //MARK: Update UI
    
    /**
     This method reloads the interface setting all the values on it. This can be done when creating the view
     or after the curren exercise has been edited.
     
     - Author: Aarón Granado Amores.
     */
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
