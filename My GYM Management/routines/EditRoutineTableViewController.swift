//
//  EditRoutineTableViewController.swift
//  My GYM Management
//
//  Created by Aaron Granado Amores on 15/5/20.
//  Copyright © 2020 AlphaDvlpr. All rights reserved.
//

import UIKit
import DLRadioButton

class EditRoutineTableViewController: UITableViewController {

    //MARK: UI Elements conection
    @IBOutlet weak var routineNameTextField: UITextField!
    @IBOutlet weak var routineInformationTextField: UITextField!
    @IBOutlet weak var routineObjectiveTextField: UITextField!
    @IBOutlet weak var routineMusclesTextField: UITextField!
    @IBOutlet weak var routineExercisesTextView: UITextView!
    @IBOutlet weak var firstColorRadioButton: DLRadioButton!
    @IBOutlet weak var secondColorRadioButton: DLRadioButton!
    @IBOutlet weak var thirdColorRadioButton: DLRadioButton!
    @IBOutlet weak var difficultRadioButton: DLRadioButton!
    @IBOutlet weak var mediumRadioButton: DLRadioButton!
    @IBOutlet weak var easyRadioButton: DLRadioButton!
    @IBOutlet weak var mondayCheckbox: UIButton!
    @IBOutlet weak var tuesdayCheckbox: UIButton!
    @IBOutlet weak var wednesdayCheckbox: UIButton!
    @IBOutlet weak var thursdayCheckbox: UIButton!
    @IBOutlet weak var fridayCheckbox: UIButton!
    @IBOutlet weak var saturdayCheckbox: UIButton!
    @IBOutlet weak var sundayCheckbox: UIButton!
    
    //MARK: Variables and constants
    var currentRoutine: Routine!
    var cons = Constants()
    var selectedDaysArray: [Bool] = [false, false, false, false, false, false, false]
    var exercisesNames: [String] = []
    var exercisesRepetitions: [String] = []
    var exercisesSeries: [String] = []
    var exercisesLoad: [String] = []
    var addExerciseDialog: AddExerciseSBViewController!
    
    //MARK: Main functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initDaysArray()
        checkColor()
        checkDifficulty()
        setupColorsAndNames()
        initExercisesArrays()
        loadData()
    }
    
    //MARK: Load data
    
    /**
     This method inits the days array depending on the days string on the routine and checks the proper checkbox.
    
     - Author: Aarón Granado Amores.
     */
    func initDaysArray() {
        let daysArray: [String] = currentRoutine.days?.split(separator: "-").map { String($0) } ?? []
        
        for day in daysArray {
            switch day {
            case "MO":
                mondayCheckbox.isSelected = true
                selectedDaysArray[0] = true
                break
            case "TU":
                tuesdayCheckbox.isSelected = true
                selectedDaysArray[1] = true
                break
            case "WE":
                wednesdayCheckbox.isSelected = true
                selectedDaysArray[2] = true
                break
            case "TH":
                thursdayCheckbox.isSelected = true
                selectedDaysArray[3] = true
                break
            case "FR":
                fridayCheckbox.isSelected = true
                selectedDaysArray[4] = true
                break
            case "SA":
                saturdayCheckbox.isSelected = true
                selectedDaysArray[5] = true
                break
            case "SU":
                sundayCheckbox.isSelected = true
                selectedDaysArray[6] = true
                break
            default:
                break
            }
        }
    }
    
    /**
     This method checks the color radioButton depending on the color stored on the routine.
    
     - Author: Aarón Granado Amores.
     */
    func checkColor() {
        let selectedColor = currentRoutine.color
        
        switch selectedColor {
        case cons.routineColorOne:
            firstColorRadioButton.isSelected = true
            break
        case cons.routineColorTwo:
            secondColorRadioButton.isSelected = true
            break
        case cons.routineColorThree:
            thirdColorRadioButton.isSelected = true
            break
        default:
            break
        }
    }
    
    /**
     This method checks the difficulty radioButton depending on the difficulty stored on the routine.
     
     - Author: Aarón Granado Amores.
     */
    func checkDifficulty() {
        let selectedDifficulty = currentRoutine.difficulty
        
        switch selectedDifficulty {
        case "difficult":
            difficultRadioButton.isSelected = true
            break
        case "medium":
            mediumRadioButton.isSelected = true
            break
        case "easy":
            easyRadioButton.isSelected = true
            break
        default:
            break
        }
    }
    
    /**
     This method loads all the data from the routine on the view.
     
     - Author: Aarón Granado Amores.
     */
    func loadData() {
        if currentRoutine != nil {
            routineNameTextField.text = currentRoutine.name
            routineInformationTextField.text = currentRoutine.info
            routineObjectiveTextField.text = currentRoutine.objective
            routineMusclesTextField.text = currentRoutine.muscles
        }
    }
    
    /**
     This method sets the colors and names for all the radio buttons depending on the values set on
     the Constants file.
     
     - Author: Aarón Granado Amores.
     */
    func setupColorsAndNames() {
        firstColorRadioButton.iconColor = UIColor.init(hexString: cons.routineColorOne)
        firstColorRadioButton.indicatorColor = UIColor.init(hexString: cons.routineColorOne)
        firstColorRadioButton.setTitleColor(UIColor.init(hexString: cons.routineColorOne), for: .normal)
        firstColorRadioButton.setTitle(cons.colorNames[0], for: .normal)
        
        secondColorRadioButton.iconColor = UIColor.init(hexString: cons.routineColorTwo)
        secondColorRadioButton.indicatorColor = UIColor.init(hexString: cons.routineColorTwo)
        secondColorRadioButton.setTitleColor(UIColor.init(hexString: cons.routineColorTwo), for: .normal)
        secondColorRadioButton.setTitle(cons.colorNames[1], for: .normal)
        
        thirdColorRadioButton.iconColor = UIColor.init(hexString: cons.routineColorThree)
        thirdColorRadioButton.indicatorColor = UIColor.init(hexString: cons.routineColorThree)
        thirdColorRadioButton.setTitleColor(UIColor.init(hexString: cons.routineColorThree), for: .normal)
        thirdColorRadioButton.setTitle(cons.colorNames[2], for: .normal)
        
        difficultRadioButton.iconColor = UIColor.init(hexString: cons.difficultyColorOne)
        difficultRadioButton.indicatorColor = UIColor.init(hexString: cons.difficultyColorOne)
        difficultRadioButton.setTitleColor(UIColor.init(hexString: cons.difficultyColorOne), for: .normal)
        
        mediumRadioButton.iconColor = UIColor.init(hexString: cons.difficultyColorTwo)
        mediumRadioButton.indicatorColor = UIColor.init(hexString: cons.difficultyColorTwo)
        mediumRadioButton.setTitleColor(UIColor.init(hexString: cons.difficultyColorTwo), for: .normal)
        
        easyRadioButton.iconColor = UIColor.init(hexString: cons.difficultyColorThree)
        easyRadioButton.indicatorColor = UIColor.init(hexString: cons.difficultyColorThree)
        easyRadioButton.setTitleColor(UIColor.init(hexString: cons.difficultyColorThree), for: .normal)
    }
    
    /**
     This method fills the exercises names, series, repetitions an load arrays and then places the formatted
     data on the execrises text view.
     
     - Author: Aarón Granado Amores.
     */
    func initExercisesArrays() {
        exercisesNames = currentRoutine.exercises?.split(separator: "-").map { String($0) } ?? []
        exercisesRepetitions = currentRoutine.repetitions?.split(separator: "-").map { String($0) } ?? []
        exercisesSeries = currentRoutine.series?.split(separator: "-").map { String($0) } ?? []
        exercisesLoad = currentRoutine.load?.split(separator: "-").map { String($0) } ?? []
        
        var exercisesText = ""
        
        if exercisesNames[0] != "no exercises" {
            for position in 0...(exercisesNames.count - 1) {
                exercisesText += exercisesNames[position] + ": "
                exercisesText += exercisesSeries[position] + "*"
                exercisesText += exercisesRepetitions[position] + " (" + exercisesLoad[position] + " KG o seg.)"
                
                if position != (exercisesNames.count - 1) {
                    exercisesText += "\n"
                }
            }
        }
        
        routineExercisesTextView.text = exercisesText
    }
    
    //MARK: IBActions

    /**
     This method sets the action for the add button.
     
     - Parameter sender: The sender of the action (In this case UIButton).
     - Author: Aarón Granado Amores.
     */
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        saveRoutine()
    }
    
    /**
     This method sets the action for the add exercise button.
     
     - Parameter sender: The sender of the action (In this case UIButton).
     - Author: Aarón Granado Amores.
     */
    @IBAction func addExerciseButtonPressed(_ sender: UIButton) {
        showNewExerciseDialog()
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
        case "L":
            selectedDaysArray[0] = sender.isSelected
            break
        case "M":
            selectedDaysArray[1] = sender.isSelected
            break
        case "X":
            selectedDaysArray[2] = sender.isSelected
            break
        case "J":
            selectedDaysArray[3] = sender.isSelected
            break
        case "V":
            selectedDaysArray[4] = sender.isSelected
            break
        case "S":
            selectedDaysArray[5] = sender.isSelected
            break
        case "D":
            selectedDaysArray[6] = sender.isSelected
            break
        default:
            break
        }
    }
    
    /**
     This method disables the green and blue radio buttons when the red one is pressed.
     
     - Parameter sender: The sender for the action (In this case DLRadioButton).
     - Author: Aarón Granado Amores.
     */
    @IBAction func firstColorRadioButtonPressed(_ sender: DLRadioButton) {
        secondColorRadioButton.isSelected = false
        thirdColorRadioButton.isSelected = false
    }
    
    /**
     This method disables the red and blue radio buttons when the green one is pressed.
     
     - Parameter sender: The sender for the action (In this case DLRadioButton).
     - Author: Aarón Granado Amores.
     */
    @IBAction func secondColorRadioButtonPressed(_ sender: DLRadioButton) {
        firstColorRadioButton.isSelected = false
        thirdColorRadioButton.isSelected = false
    }
    
    /**
     This method disables the green and red radio buttons when the blue one is pressed.
     
     - Parameter sender: The sender for the action (In this case DLRadioButton).
     - Author: Aarón Granado Amores.
     */
    @IBAction func thirdColorRadioButtonPressed(_ sender: DLRadioButton) {
        secondColorRadioButton.isSelected = false
        firstColorRadioButton.isSelected = false
    }
    
    /**
     This method disables the easy and medium radio buttons when the difficult one is pressed.
     
     - Parameter sender: The sender for the action (In this case DLRadioButton).
     - Author: Aarón Granado Amores.
     */
    @IBAction func difficultRadioButtonPressed(_ sender: DLRadioButton) {
        easyRadioButton.isSelected = false
        mediumRadioButton.isSelected = false
    }
    
    /**
     This method disables the difficult and easy radio buttons when the medium one is pressed.
     
     - Parameter sender: The sender for the action (In this case DLRadioButton).
     - Author: Aarón Granado Amores.
     */
    @IBAction func mediumRadioButtonPressed(_ sender: DLRadioButton) {
        difficultRadioButton.isSelected = false
        easyRadioButton.isSelected = false
    }
    
    /**
     This method disables the difficult and medium radio buttons when the easy one is pressed.
     
     - Parameter sender: The sender for the action (In this case DLRadioButton).
     - Author: Aarón Granado Amores.
     */
    @IBAction func easyRadioButtonPressed(_ sender: DLRadioButton) {
        difficultRadioButton.isSelected = false
        mediumRadioButton.isSelected = false
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
        if checkIfAnyDayIsSelected() {
            var checkedColor: String = cons.predefinedRoutineColor
            var checkedDifficulty: String = "none"
            
            if firstColorRadioButton.isSelected { checkedColor = String(cons.routineColorOne) }
            if secondColorRadioButton.isSelected { checkedColor = String(cons.routineColorTwo) }
            if thirdColorRadioButton.isSelected { checkedColor = String(cons.routineColorThree) }
            if difficultRadioButton.isSelected { checkedDifficulty = "difficult" }
            if mediumRadioButton.isSelected { checkedDifficulty = "medium" }
            if easyRadioButton.isSelected { checkedDifficulty = "easy" }
            
            currentRoutine.days = createDaysString()
            currentRoutine.color = checkedColor
            currentRoutine.difficulty = checkedDifficulty
            currentRoutine.exercises = createExercisesNamesString()
            currentRoutine.series = createExercisesSeriesString()
            currentRoutine.repetitions = createExercisesRepetitionsString()
            currentRoutine.load = createExercisesLoadString()
            
            if routineInformationTextField.text != "" { currentRoutine.info = routineInformationTextField.text }
            if routineMusclesTextField.text != "" { currentRoutine.muscles = routineMusclesTextField.text }
            if routineObjectiveTextField.text != "" { currentRoutine.objective = routineObjectiveTextField.text}
            
            saveToCD()
        } else {
            showInfoAlert(message: "Debes seleccionar al menos un día")
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
    
    //MARK: Helpers
    
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
     This method gets the selected 'checkboxes' and converts the selected ones to String.
     
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
    
    /**
     This method creates a String with the names of all the exercises selected.
     
     - Returns: Returns a String containing the names separated with **'-'** or **'no exercises'** if there
     is no exercise selected.
     - Author: Aarón Granado Amores.
     */
    func createExercisesNamesString() -> String {
        if exercisesNames.count != 0 {
            var namesString = ""
            
            for position in 0...(exercisesNames.count - 1) {
                namesString += exercisesNames[position]
                
                if position != (exercisesNames.count - 1) {
                    namesString += "-"
                }
            }
            
            return namesString
        }
        
        return "no exercises"
    }
    
    /**
     This method creates a String with the series of all the exercises selected.
     
     - Returns: Returns a String containing the series separated with **'-'** or **'no series'** if there
     is no exercise selected.
     - Author: Aarón Granado Amores.
     */
    func createExercisesSeriesString() -> String {
        if exercisesSeries.count != 0 {
            var seriesString = ""
            
            for position in 0...(exercisesSeries.count - 1) {
                seriesString += exercisesSeries[position]
                
                if position != (exercisesSeries.count - 1) {
                    seriesString += "-"
                }
            }
            
            return seriesString
        }
        
        return "no series"
    }
    
    /**
     This method creates a String with the names of all the exercises selected.
     
     - Returns: Returns a String containing the names separated with **'-'** or **'no exercises'** if there
     is no exercise selected.
     - Author: Aarón Granado Amores.
     */
    func createExercisesRepetitionsString() -> String {
        if exercisesRepetitions.count != 0 {
            var repetitionsString = ""
            
            for position in 0...(exercisesRepetitions.count - 1) {
                repetitionsString += exercisesRepetitions[position]
                
                if position != (exercisesRepetitions.count - 1) {
                    repetitionsString += "-"
                }
            }
            
            return repetitionsString
        }
        
        return "no exercises"
    }
    
    /**
     This method creates a String with the names of all the exercises selected.
     
     - Returns: Returns a String containing the names separated with **'-'** or **'no exercises'** if there
     is no exercise selected.
     - Author: Aarón Granado Amores.
     */
    func createExercisesLoadString() -> String {
        if exercisesLoad.count != 0 {
            var loadString = ""
            
            for position in 0...(exercisesLoad.count - 1) {
                loadString += exercisesLoad[position]
                
                if position != (exercisesLoad.count - 1) {
                    loadString += "-"
                }
            }
            
            return loadString
        }
        
        return "no exercises"
    }
    
    //MARK: AlertDialog
    
    /**
     This method creates a custom alert for adding a new exercise to the current routine.
     
     - Author: Aarón Granado Amores.
     */
    func showNewExerciseDialog() {
        let storyboard = UIStoryboard(name: "AddExercise", bundle: nil)
        addExerciseDialog = (storyboard.instantiateViewController(withIdentifier: "AddExerciseCustomDialog") as! AddExerciseSBViewController)
        
        addExerciseDialog.providesPresentationContextTransitionStyle = true
        addExerciseDialog.definesPresentationContext = true
        addExerciseDialog.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        addExerciseDialog.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        addExerciseDialog.delegate = self
        
        self.present(addExerciseDialog, animated: true, completion: nil)
    }
    
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
    
    // MARK: TableView DataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 1 ? 5 : 2
    }
    
    //MARK: TableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension EditRoutineTableViewController: CustomExerciseAlertDialogDelegate {
    //MARK: CustomExerciseAlertDialogDelegate
    func cancelButtonPressed() {}
    
    func addButtonPressed(name: String, series: String, repetitions: String, load: String) {
        let currentText = routineExercisesTextView.text ?? ""
        var newText = currentText == "" ? "" : (currentText + "\n")
        newText += name + ": "
        newText += series + "*"
        newText += repetitions + " (" + load + " KG o sec.)"
        
        routineExercisesTextView.text = newText
        
        if exercisesNames[0] == "no exercises" {
            exercisesNames = []
            exercisesSeries = []
            exercisesRepetitions = []
            exercisesLoad = []
        }
        
        exercisesNames.append(name)
        exercisesSeries.append(series)
        exercisesRepetitions.append(repetitions)
        exercisesLoad.append(load)
    }
}
