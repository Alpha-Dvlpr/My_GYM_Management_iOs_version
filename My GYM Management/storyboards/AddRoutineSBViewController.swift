//
//  AddRoutineSBViewController.swift
//  My GYM Management
//
//  Created by Aaron Granado Amores on 6/5/20.
//  Copyright © 2020 AlphaDvlpr. All rights reserved.
//

import UIKit
import DLRadioButton

protocol CustomRoutineAlertDialogDelegate: class {
    func addButtonPressed()
    func cancelButtonPressed()
}

class AddRoutineSBViewController: UIViewController {

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
    func setupView() {
        alertView.layer.cornerRadius = 15
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }
    
    func animateView() {
        alertView.alpha = 0;
        self.alertView.frame.origin.y = self.alertView.frame.origin.y + 50
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.alertView.alpha = 1.0;
            self.alertView.frame.origin.y = self.alertView.frame.origin.y - 50
        })
    }
    
    func checkIfAnyDayIsSelected() -> Bool {
        var selectedDays = 0
        
        for day in selectedDaysArray {
            if day == true { selectedDays += 1 }
        }
        
        if selectedDays == 0 { return false }
        
        return true
    }
    
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
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        nameTextField.resignFirstResponder()
        delegate?.cancelButtonPressed()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        nameTextField.resignFirstResponder()
        delegate?.addButtonPressed()
        saveRoutine()
    }
    
    @IBAction func redRadioButtonPressed(_ sender: DLRadioButton) {
        greenRadioButton.isSelected = false
        blueRadioButton.isSelected = false
    }
    
    @IBAction func greenRadioButtonPressed(_ sender: DLRadioButton) {
        redRadioButton.isSelected = false
        blueRadioButton.isSelected = false
    }
    
    @IBAction func blueRadioButtonPressed(_ sender: DLRadioButton) {
        greenRadioButton.isSelected = false
        redRadioButton.isSelected = false
    }
    
    @IBAction func changeCheckBoxStatus(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
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
    
    func saveToCD() {
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    //MARK: AlertDialog
    func showInfoAlert(message: String) {
        let alertController = UIAlertController(title: "INFO", message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
}
