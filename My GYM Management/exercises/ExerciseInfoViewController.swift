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
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var executionLabel: UILabel!
    @IBOutlet weak var musclesLabel: UILabel!
    @IBOutlet weak var openLinkOutlet: UIBarButtonItem!
    @IBOutlet weak var editButtonOutlet: UIBarButtonItem!
    
    //MARK: Variables and constants
    var localExercise: Exercise!
    
    //MARK: Main functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        updateUI()
    }
    
    //MARK: IBActions
    
    /**
     This method opens the link if the user has any application that can open it.
     
     - Parameter sender: The sender for the action (In this case UIButton).
     - Author: Aarón Granado Amores.
     */
    @IBAction func openLinkButtonPressed(_ sender: UIBarButtonItem) {
        if checkURL(url: localExercise.link ?? "no link") {
            if let linkURL = URL(string: localExercise.link ?? "https://www.google.es") {
                UIApplication.shared.open(linkURL)
            }
        } else {
            showInfoAlert(message: "No se puede abrir el enlace.\nPuede que esté mal introducido.")
        }
    }
    
    /**
     This method sets the action for the send exercise button.
     
     - Parameter sender: the sender or the action (In this case UIButton).
     - Author: Aarón Granado Amores.
     */
    @IBAction func sendButtonPressed(_ sender: UIBarButtonItem) {
        showInfoAlert(message: "Próximamente")
    }
    
    //MARK: Check URL
    
    /**
     This method checks if the URL is correct and can be opened by the browser.
     
     - Parameter url: The URL to check.
     - Returns: Returns **true** if the link is correct and **false** if not.
     - Author: Aarón Granado Amores.
     */
    func checkURL(url: String) -> Bool {
        if url.hasPrefix("http://") || url.hasPrefix("https://") {
            return true
        }
        
        return false
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
            nameLabel.text = localExercise.name
            infoLabel.text = localExercise.info
            executionLabel.text = localExercise.execution
            musclesLabel.text = (localExercise.muscles == nil || localExercise.muscles == "") ? "No hay músculos" : localExercise.muscles
            
            if localExercise.link != nil && localExercise.link != "" {
                openLinkOutlet.isEnabled = true
            } else {
                openLinkOutlet.isEnabled = false
            }
            
            editButtonOutlet.isEnabled = localExercise.isUserCreated
        }
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditExercise" {
            let infoVC = segue.destination as! EditExerciseTableViewController
            
            infoVC.currentExercise = self.localExercise
        }
    }
}
