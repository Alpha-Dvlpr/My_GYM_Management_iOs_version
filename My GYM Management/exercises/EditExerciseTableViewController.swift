//
//  EditExerciseTableViewController.swift
//  My GYM Management
//
//  Created by Aaron Granado Amores on 14/5/20.
//  Copyright © 2020 AlphaDvlpr. All rights reserved.
//

import UIKit

class EditExerciseTableViewController: UITableViewController {

    //MARK: UI Elements connection
    @IBOutlet weak var exerciseNameTextField: UITextField!
    @IBOutlet weak var exerciseInformationTextField: UITextField!
    @IBOutlet weak var exerciseExecutionTextField: UITextField!
    @IBOutlet weak var exerciseLinkTextField: UITextField!
    @IBOutlet weak var exerciseMusclesTextField: UITextField!
    
    //MARK: Variables and constants
    var currentExercise: Exercise!
    
    //MARK: Main function
    override func viewDidLoad() {
        super.viewDidLoad()
    
        loadData()
    }
    
    //MARK: Load data
    
    /**
     This method loads the received information into the view.
     
     - Author: Aarón Granado Amores.
     */
    func loadData() {
        if currentExercise != nil {
            exerciseNameTextField.text = currentExercise.name
            exerciseInformationTextField.text = currentExercise.info
            exerciseExecutionTextField.text = currentExercise.execution
            exerciseLinkTextField.text = currentExercise.link
            exerciseMusclesTextField.text = currentExercise.muscles
        } else {
            exerciseInformationTextField.isEnabled = false
            exerciseExecutionTextField.isEnabled = false
            exerciseLinkTextField.isEnabled = false
            exerciseMusclesTextField.isEnabled = false
        }
    }
    
    //MARK: IBActions
    
    /**
     This method set the action for the save button.
     
     - Parameter sender: The sender of the action (In this case UIBarButtonItem).
     - Author: Aarón Granado Amores.
     */
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        saveExercise()
    }
    
    //MARK: Save to CoreData
    
    /**
     This method checks if the information on the view is correct. It shows an alert if there's an error
     or missing required data.
     
     ## Important Note ##
     1. The required values are: **name**, **info**, **execution**.
     2. **'isUserCreated'** remains **'true'**.
     
     - Author: Aarón Granado Amores.
     */
    func saveExercise() {
        if exerciseInformationTextField.text != "" && exerciseExecutionTextField.text != "" {
            currentExercise.info = exerciseInformationTextField.text
            currentExercise.execution = exerciseExecutionTextField.text
            currentExercise.link = exerciseLinkTextField.text
            currentExercise.muscles = exerciseMusclesTextField.text
            
            saveToCD()
        } else {
            showInfoAlert(message: "Debes completar todos los campos obligatorios")
        }
    }
    
    /**
     This method saves the current context of the app to CoreData it also closes the current ViewController.
     
     - Author: Aarón Granado Amores.
     */
    func saveToCD() {
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: AlertDialog
    
    /**
     This method shows an Alert with the given message.
     
     - Parameter message: The message to be displayed.
     - Author: Aarón Granado Amores.
     */
    func showInfoAlert(message: String) {
        let alertController = UIAlertController(title: "INFO", message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: TableView Data Source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 3 : 2
    }
    
    //MARK: TableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
