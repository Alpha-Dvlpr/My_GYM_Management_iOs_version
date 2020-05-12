//
//  AddExerciseSBViewController.swift
//  My GYM Management
//
//  Created by Aaron Granado Amores on 7/5/20.
//  Copyright © 2020 AlphaDvlpr. All rights reserved.
//

import UIKit
import CoreData

/**
 This protocol connects this alert with the class where it is called.
 
 ## Important Note ##
 1. Both methods are required.
 
 - Author: Aarón Granado Amores.
 */
protocol CustomExerciseAlertDialogDelegate: class {
    /// The cancel button connection
    func cancelButtonPressed()
    
    /// The add button connection
    func addButtonPressed()
}

class AddExerciseSBViewController: UIViewController {
    
    //MARK: UI Elements connection
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var infoTextField: UITextField!
    @IBOutlet weak var executionTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var musclesTextField: UITextField!
    @IBOutlet weak var alertView: UIView!
    
    //MARK: Variables and constants
    var delegate: CustomExerciseAlertDialogDelegate?
    
    //MARK: Main functions
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupView()
        animateView()
    }
    
    //MARK: Helpers
    
    /**
     This function setups the AlertView to have rounded corners and sets the view's background to imitate system
     AlertController.
     
     - Author: Aarón Granado Amores.
     */
    func setupView() {
        alertView.layer.cornerRadius = 15
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }
    
    /**
     This function animates the AlertController when appearing.
     
     - Author: Aarón Granado Amores.
     */
    func animateView() {
        alertView.alpha = 0;
        self.alertView.frame.origin.y = self.alertView.frame.origin.y + 50
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.alertView.alpha = 1.0;
            self.alertView.frame.origin.y = self.alertView.frame.origin.y - 50
        })
    }
    
    /**
     This method sets new constraints to the dialog when the keyboard is open in order to center it on the
     free space on the screeen
     
     - Parameter offsetHeight: The value to be added on the bottom constraint, this is given by the keyboard height.
     - Author: Aarón Granado Amores.
     */
    public func updateExecriseAlertConstraints(offsetHeight: CGFloat) {
        let viewHeight: CGFloat = alertView.bounds.height
        let screenHeight: CGFloat = UIScreen.main.bounds.height
        let freeSpace: CGFloat = screenHeight - offsetHeight - viewHeight
        let constraint: CGFloat = freeSpace / 2
        
        alertView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: constraint).isActive = true
        alertView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -(constraint + offsetHeight)).isActive = true
    }
    
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
            print("Error checking routine")
            return true
        }
        
        return false
    }
    
    //MARK: IBActions
    
    /**
     This method dismisses the alert when the cancel button is pressed.
     
     - Parameter sender: The sender of the action (In this case UIButton).
     - Author: Aarón Granado Amores.
     */
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        nameTextField.resignFirstResponder()
        delegate?.cancelButtonPressed()
        self.dismiss(animated: true, completion: nil)
    }
    
    /**
     This method calls the 'saveExercise' method.
     
     - Parameter sender: The sender of the action (In this case UIButton).
     - Author: Aarón Granado Amores.
     */
    @IBAction func addButtonPressed(_ sender: UIButton) {
        nameTextField.resignFirstResponder()
        delegate?.addButtonPressed()
        saveExercise()
    }
    
    //MARK: Save to CD
    
    /**
     This method checks if the information on the alert is correct. It shows an alert if there's an error
     or missing required data.
     
     ## Important Note ##
     1. The required values are: **name**, **info**, **execution**, **isUserCreated**.
     2. 'isUserCreated' is always **true** for user created exercises.
     
     - Author: Aarón Granado Amores.
     */
    func saveExercise() {
        if nameTextField.text != "" {
            if !checkIfExerciseExistsOnCoreData(name: nameTextField.text!) {
                if infoTextField.text != "" && executionTextField.text != "" {
                    let exerciseToSave: Exercise = Exercise(context: AppDelegate.context)
                    
                    exerciseToSave.name = nameTextField.text
                    exerciseToSave.info = infoTextField.text
                    exerciseToSave.execution = executionTextField.text
                    exerciseToSave.isUserCreated = true
                    
                    if linkTextField.text != "" { exerciseToSave.link = linkTextField.text }
                    if musclesTextField.text != "" { exerciseToSave.muscles = musclesTextField.text }
                    
                    saveToCD()
                    self.dismiss(animated: true, completion: nil)
                } else {
                    showInfoAlert(message: "Todos los campos con '*' son obligatorios")
                }
            } else {
                showInfoAlert(message: "Ya existe un ejercicio con el nombre '\(nameTextField.text!)'")
            }
        } else {
            showInfoAlert(message: "Debes introducir un nombre")
        }
    }
    
    /**
     This method saves the current context of the app to CoreData.
     It can be after adding, editing or deleting any element.
     
     - Author: Aarón Granado Amores.
     */
    func saveToCD() {
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
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
}
