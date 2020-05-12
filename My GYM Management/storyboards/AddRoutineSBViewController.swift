//
//  AddRoutineSBViewController.swift
//  My GYM Management
//
//  Created by Aaron Granado Amores on 6/5/20.
//  Copyright © 2020 AlphaDvlpr. All rights reserved.
//

import UIKit
import DLRadioButton

/**
 This protocol connects this alert with the class where it is called.
 
 ## Important Note ##
 1. Both methods are required.
 
 - Author: Aarón Granado Amores.
 */
protocol CustomRoutineAlertDialogDelegate: class {
    /// The add button connection.
    func addButtonPressed()
    
    /// The cancel button connection.
    func cancelButtonPressed()
}

class AddRoutineSBViewController: UIViewController{

    //MARK: UI elements connection
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet var alertView: UIView!
    @IBOutlet weak var redRadioButton: DLRadioButton!
    @IBOutlet weak var greenRadioButton: DLRadioButton!
    @IBOutlet weak var blueRadioButton: DLRadioButton!
    @IBOutlet weak var mondayCheckbox: UIButton!
    @IBOutlet weak var tuesdayCheckbox: UIButton!
    @IBOutlet weak var wednesdayCheckbox: UIButton!
    @IBOutlet weak var thursdayCheckbox: UIButton!
    @IBOutlet weak var fridayCheckbox: UIButton!
    @IBOutlet weak var saturdayCheckbox: UIButton!
    @IBOutlet weak var sundayCheckbox: UIButton!
    
    //MARK: Variables and constants
    var delegate: CustomRoutineAlertDialogDelegate?
    var cons: Constants = Constants()
    var selectedDaysArray: [Bool] = [false, false, false, false, false, false, false]
    var bottomConstraint: NSLayoutConstraint?
    
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
    public func updateConstraints(offsetHeight: CGFloat) {
        let viewHeight: CGFloat = alertView.bounds.height
        let screenHeight: CGFloat = UIScreen.main.bounds.height
        let freeSpace: CGFloat = screenHeight - offsetHeight - viewHeight
        let constraint: CGFloat = freeSpace / 2
        
        alertView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: constraint).isActive = true
        alertView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -(constraint + offsetHeight)).isActive = true
    }
    
    /**
     This method checks if any of the 'checkboxes' for the days is selected.
     
     - Returns: Returns **true** if at least one day is selected and **false** if there's none selected.
     - Author: Aarón Granado Amores.
     */
    func checkIfAnyDayIsSelected() -> Bool {
        var selectedDays = 0
        
        for day in selectedDaysArray {
            if day == true { selectedDays += 1 }
        }
        
        if selectedDays == 0 { return false }
        
        return true
    }
    
    /**
     This method gets the seelcted 'checkboxes' and converts the selected ones to String.
     
     - Returns: Returns a String containing the selected days separated with **'-'**.
     - Author: Aarón Granado Amores.
     */
    func createDaysString() -> String {
        var daysString = ""
        
        daysString += selectedDaysArray[0] ? "MO" : ""
        daysString += selectedDaysArray[1] ? (daysString.count == 0 ? "TU" : "-TU") : ""
        daysString += selectedDaysArray[2] ? (daysString.count == 0 ? "WE" : "-WE") : ""
        daysString += selectedDaysArray[3] ? (daysString.count == 0 ? "TH" : "-TH") : ""
        daysString += selectedDaysArray[4] ? (daysString.count == 0 ? "FR" : "-FR") : ""
        daysString += selectedDaysArray[5] ? (daysString.count == 0 ? "SA" : "-SA") : ""
        daysString += selectedDaysArray[6] ? (daysString.count == 0 ? "SU" : "-SU") : ""
        
        return daysString
    }
    
    //MARK: IBActions
    
    /**
     This method sets the action for the cancel button.
     
     - Parameter sender: The sender of the action (In this case UIButton).
     - Author: Aarón Granado Amores.
     */
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        nameTextField.resignFirstResponder()
        delegate?.cancelButtonPressed()
        self.dismiss(animated: true, completion: nil)
    }
    
    /**
     This method sets the action for the add button.
     
     - Parameter sender: The sender of the action (In this case UIButton).
     - Author: Aarón Granado Amores.
     */
    @IBAction func addButtonPressed(_ sender: UIButton) {
        nameTextField.resignFirstResponder()
        delegate?.addButtonPressed()
        saveRoutine()
    }
    
    /**
     This method disables the green and blue radio buttons when the red one is pressed.
     
     - Parameter sender: The sender for the action (In this case DLRadioButton).
     - Author: Aarón Granado Amores.
     */
    @IBAction func redRadioButtonPressed(_ sender: DLRadioButton) {
        greenRadioButton.isSelected = false
        blueRadioButton.isSelected = false
    }
    
    /**
     This method disables the red and blue radio buttons when the green one is pressed.
     
     - Parameter sender: The sender for the action (In this case DLRadioButton).
     - Author: Aarón Granado Amores.
     */
    @IBAction func greenRadioButtonPressed(_ sender: DLRadioButton) {
        redRadioButton.isSelected = false
        blueRadioButton.isSelected = false
    }
    
    /**
     This method disables the green and red radio buttons when the blue one is pressed.
     
     - Parameter sender: The sender for the action (In this case DLRadioButton).
     - Author: Aarón Granado Amores.
     */
    @IBAction func blueRadioButtonPressed(_ sender: DLRadioButton) {
        greenRadioButton.isSelected = false
        redRadioButton.isSelected = false
    }
    
    /**
     This method enables or disables a checkbox when it is pressed.
     
     - Parameter sender: The sender for the action (In this case UIButton that acts as a checkbox).
     - Author: Aarón Granado Amores.
     */
    @IBAction func changeCheckBoxStatus(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    /**
     This method changes the value of the days array depending on the sender label
     
     - Parameter sender: The sender of the action (In this case we know it is UIButton).
     - Author: Aarón Granado Amores.
     */
    @IBAction func changeSelectedDay(_ sender: UIButton) {
        switch sender.titleLabel?.text {
        case "LU":
            selectedDaysArray[0] = sender.isSelected
            break
        case "MA":
            selectedDaysArray[1] = sender.isSelected
            break
        case "MI":
            selectedDaysArray[2] = sender.isSelected
            break
        case "JU":
            selectedDaysArray[3] = sender.isSelected
            break
        case "VI":
            selectedDaysArray[4] = sender.isSelected
            break
        case "SA":
            selectedDaysArray[5] = sender.isSelected
            break
        case "DO":
            selectedDaysArray[6] = sender.isSelected
            break
        default:
            break
        }
    }
    
    //MARK: Save to CD
    
    /**
     This method checks if the information on the alert is correct. It shows an alert if there's an error
     or missing required data.
     
     ## Important Note ##
     1. The required values are: **name**, **color**, **days**, **isUserCreated**.
     2. The predefined color, if no radiobutton is selected is **'#3DFFEC'**.
     3. 'isUserCreated' is always **true** for user created routines.
     
     - Author: Aarón Granado Amores.
     */
    func saveRoutine() {
        // Check if there's a routine with the same name.
        
        if nameTextField.text != "" {
            if !checkIfAnyDayIsSelected() {
                showInfoAlert(message: "Debes seleccionar al menos un día")
            } else {
                let routineToSave: Routine = Routine(context: AppDelegate.context)
                var checkedColor: String = cons.predefinedRoutineColor
                
                if redRadioButton.isSelected {
                    checkedColor = String(cons.routineColorOne)
                }
                
                if greenRadioButton.isSelected {
                    checkedColor = String(cons.routineColorTwo)
                }
                
                if blueRadioButton.isSelected {
                    checkedColor = String(cons.routineColorThree)
                }
            
                routineToSave.name = nameTextField.text
                routineToSave.color = checkedColor
                routineToSave.days = createDaysString()
                routineToSave.isUserCreated = true
                
                if descriptionTextField.text != "" { routineToSave.info = descriptionTextField.text }
                
                saveToCD()
                self.dismiss(animated: true, completion: nil)
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
