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
    
    //MARK: Variables and constants
    var didCameFromExerciseInfo: Bool = false
    var exerciseToEdit: Exercise!
    
    //MARK: Main function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
    }
    
    //MARK: Init view
    
    /**
     This method loads the information on the view if it has been called from the exercise information view to edit it.
     
     - Author: Aarón Granado Amores.
     */
    func initView() {
        if !didCameFromExerciseInfo {
            self.title = "NUEVO"
        } else {
            self.title = "EDITAR"
            exerciseNameTextField.isEnabled = false
            exerciseNameTextField.text = exerciseToEdit.name
            exerciseInformationTextField.text = exerciseToEdit.info
            exerciseExecutionTextField.text = exerciseToEdit.execution
            exerciseLinkTextField.text = exerciseToEdit.link
            exerciseMusclesTextField.text = exerciseToEdit.muscles
        }
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
        if exerciseNameTextField.text != "" && exerciseInformationTextField.text != "" && exerciseExecutionTextField.text != "" {
            if didCameFromExerciseInfo {
                setExecriseInformation(exercise: exerciseToEdit)
            } else {
                if !checkIfExerciseExistsOnCoreData(name: exerciseNameTextField.text!) {
                    setExecriseInformation(exercise: Exercise(context: AppDelegate.context))
                } else {
                    showInfoAlert(message: "Ya existe un ejercicio con el nombre '\(exerciseNameTextField.text!)'")
                }
            }
        } else {
            showInfoAlert(message: "Debes completar todos los campos obligatorios")
        }
    }
    
    
    /**
     This method sets the values for all the fields of the exercise and then saves it to CoreData. This can be used to add
     a new Exercise or to update an existing one.
     
     - Parameter exercise: The exercise to be added or edited.
     - Author: Aarón Granado Amores.
     */
    func setExecriseInformation(exercise: Exercise) {
        exercise.name = exerciseNameTextField.text?.uppercased()
        exercise.info = exerciseInformationTextField.text
        exercise.execution = exerciseExecutionTextField.text
        exercise.isUserCreated = true
        
        if exerciseLinkTextField.text != "" { exercise.link = exerciseLinkTextField.text }
        if exerciseMusclesTextField.text != "" { exercise.muscles = exerciseMusclesTextField.text }
        
        saveToCD()
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
