//
//  AddExerciseTableViewController.swift
//  My GYM Management
//
//  Created by Aaron Granado Amores on 13/5/20.
//  Copyright © 2020 AlphaDvlpr. All rights reserved.
//

import UIKit
import CoreData

class AddExerciseTableViewController: UITableViewController {

    //MARK: UI Elements connection
    @IBOutlet weak var exerciseNameTextField: UITextField!
    @IBOutlet weak var exerciseInformationTextField: UITextField!
    @IBOutlet weak var exerciseExecutionTextField: UITextField!
    @IBOutlet weak var exerciseLinkTextField: UITextField!
    @IBOutlet weak var exerciseMusclesTextField: UITextField!
    
    //MARK: Main function
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: IBActions
    
    /**
     This method calls the 'saveExercise' method.
     
     - Parameter sender: The sender of the action (In this case UIBarButton).
     - Author: Aarón Granado Amores.
     */
    @IBAction func saveExerciseButtonPressed(_ sender: UIBarButtonItem) {
        saveExercise()
    }
    
    //MARK: Save to CoreData
    
    /**
     This method checks if the information on the view is correct. It shows an alert if there's an error
     or missing required data.
     
     ## Important Note ##
     1. The required values are: **name**, **info**, **execution**, **isUserCreated**.
     2. 'isUserCreated' is always **true** for user created exercises.
     
     - Author: Aarón Granado Amores.
     */
    func saveExercise() {
        if exerciseNameTextField.text != "" {
            if !checkIfExerciseExistsOnCoreData(name: exerciseNameTextField.text!) {
                if exerciseInformationTextField.text != "" && exerciseExecutionTextField.text != "" {
                    let exerciseToSave: Exercise = Exercise(context: AppDelegate.context)
                    
                    exerciseToSave.name = exerciseNameTextField.text
                    exerciseToSave.info = exerciseInformationTextField.text
                    exerciseToSave.execution = exerciseExecutionTextField.text
                    exerciseToSave.isUserCreated = true
                    
                    if exerciseLinkTextField.text != "" { exerciseToSave.link = exerciseLinkTextField.text }
                    if exerciseMusclesTextField.text != "" { exerciseToSave.muscles = exerciseMusclesTextField.text }
                    
                    saveToCD()
                } else {
                    showInfoAlert(message: "Debes completar todos los campos obligatorios")
                }
            } else {
                showInfoAlert(message: "Ya existe un ejercicio con el nombre '\(exerciseNameTextField.text!)'")
            }
        } else {
            showInfoAlert(message: "Debes introducir un nombre")
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
    
    //MARK: Helpers
    
    /**
     This method checks if there is an exercise with the same name on Core Data.
     
     - Parameter name: The name of the execrise to be checked.
     - Returns: Returns **true** if the exercise already exists and  **false** if not.
     - Author: Aarón Granado Amores.
     */
    func checkIfExerciseExistsOnCoreData(name: String) -> Bool{
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Exercise")
        
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        do {
            let result = try AppDelegate.context.fetch(fetchRequest)
            
            if result.count != 0 {
                return true
            }
        } catch {
            print("Error checking exercise")
            return true
        }
        
        return false
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
