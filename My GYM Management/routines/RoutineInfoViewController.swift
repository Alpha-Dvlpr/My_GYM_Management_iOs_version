//
//  RoutineInfoViewController.swift
//  My GYM Management
//
//  Created by Aaron Granado Amores on 7/5/20.
//  Copyright © 2020 AlphaDvlpr. All rights reserved.
//

import UIKit
import Foundation

class RoutineInfoViewController: UIViewController {

    //MARK: UI Elements connection
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var objectiveLabel: UILabel!
    @IBOutlet weak var exercisesLabel: UILabel!
    @IBOutlet weak var musclesLabel: UILabel!
    @IBOutlet weak var mondayOutlet: UIButton!
    @IBOutlet weak var tuesdayOutlet: UIButton!
    @IBOutlet weak var wednesdayOutlet: UIButton!
    @IBOutlet weak var thursdayOutlet: UIButton!
    @IBOutlet weak var fridayOutlet: UIButton!
    @IBOutlet weak var saturdayOutlet: UIButton!
    @IBOutlet weak var sundayOutlet: UIButton!
    @IBOutlet weak var editRoutineOutlet: UIBarButtonItem!
    @IBOutlet weak var difficultyIndicator: UIBarButtonItem!
    
    //MARK: Variables and constants
    var localRoutine: Routine!
    var cons = Constants()
    
    //MARK: Main functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        updateUI()
    }
    
    //MARK: UpdateUI
    
    /**
     This method set all the information on the view. This can be when the view is created or after the routine
     is edited.
     
     ## Important Notes ##
     1. The edit button is only enabled for user created routines and not for custom ones.
     
     - Author: Aarón Granado Amores.
     */
    func updateUI() {
        if localRoutine != nil {
            let daysArray: [String] = localRoutine.days?.split(separator: "-").map { String($0) } ?? []
            let exercisesArray: [String] = localRoutine.exercises?.split(separator: "-").map { String($0) } ?? []
            let repetitionsArray: [String] = localRoutine.repetitions?.split(separator: "-").map { String($0) } ?? []
            let seriesArray: [String] = localRoutine.series?.split(separator: "-").map { String($0) } ?? []
            let loadArray: [String] = localRoutine.load?.split(separator: "-").map { String($0) } ?? []
            
            setColorToDifficultyIndicator(difficulty: localRoutine.difficulty ?? "none")
            nameLabel.text = localRoutine.name
            infoLabel.text = localRoutine.info ?? "No hay información"
            setColorToDays(days: daysArray, color: localRoutine.color!)
            objectiveLabel.text = localRoutine.objective ?? "No hay ningún objetivo definido para esta rutina"
            setExercises(exercises: exercisesArray, repetitions: repetitionsArray, series: seriesArray, load: loadArray)
            musclesLabel.text = localRoutine.muscles ?? "No hay músculos implicados en esta rutina"
            
            editRoutineOutlet.isEnabled = localRoutine.isUserCreated
            
        } else {
            self.title = "ERROR"
        }
    }
    
    //MARK: IBActions
    
    /**
     This method sets the action for the send routine button
     
     - Parameter sender: The sender of the action (In this case UIButton).
     - Author: Aarón Granado Amores.
     */
    @IBAction func sendRoutinePressed(_ sender: UIBarButtonItem) {
        showInfoAlert(message: "Próximamente")
    }
    
    /**
     This method sets the action for the edit routine button. It opens the addRoutineViewController for editing the
     current routine.
     
     - Parameter sender: the sender o the action (In this case UIBarButton).
     - Author: Aarón Granado Amores.
     */
    @IBAction func editRoutineButtonPressed(_ sender: UIBarButtonItem) {
        let infoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "addEditRoutine") as! AddRoutineTableViewController
        
        navigationController?.pushViewController(infoVC, animated: true)
        infoVC.didCameFromEditRoutine = true
        infoVC.routineToEdit = self.localRoutine
    }
    
    //MARK: AlertDialog
    
    /**
     This method shows an alert with the given message.
     
     - Parameter message: The message to be displayed.
     - Author: Aarón Granado Amores.
     */
    func showInfoAlert(message: String) {
        let infoAlert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        
        infoAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        self.present(infoAlert, animated: true, completion: nil)
    }
    
    //MARK: Helpers
    
    /**
     This method sets the background for the days view depending on the color and days array given.
     
     - Parameter days: A String array containig the days that the routine has to be trained. This array is
     created on 'updateUI()'.
     - Parameter color: The color to be set as background for each day.
     - Author: Aarón Granado Amores.
     */
    func setColorToDays(days: [String], color: String) {
        var booleanDays: [Bool] = [false, false, false, false, false, false, false]
        
        for day in days {
            switch day {
            case "MO":
                booleanDays[0] = true
                break
            case "TU":
                booleanDays[1] = true
                break
            case "WE":
                booleanDays[2] = true
                break
            case "TH":
                booleanDays[3] = true
                break
            case "FR":
                booleanDays[4] = true
                break
            case "SA":
                booleanDays[5] = true
                break
            case "SU":
                booleanDays[6] = true
                break
            default:
                break
            }
        }
        
        mondayOutlet.backgroundColor = booleanDays[0] ? UIColor(hexString: color) : UIColor.white
        mondayOutlet.setTitleColor(booleanDays[0] ? UIColor.white : UIColor.black, for: .normal)
        
        tuesdayOutlet.backgroundColor = booleanDays[1] ? UIColor(hexString: color) : UIColor.white
        tuesdayOutlet.setTitleColor(booleanDays[1] ? UIColor.white : UIColor.black, for: .normal)
        
        wednesdayOutlet.backgroundColor = booleanDays[2] ? UIColor(hexString: color) : UIColor.white
        wednesdayOutlet.setTitleColor(booleanDays[2] ? UIColor.white : UIColor.black, for: .normal)
        
        thursdayOutlet.backgroundColor = booleanDays[3] ? UIColor(hexString: color) : UIColor.white
        thursdayOutlet.setTitleColor(booleanDays[3] ? UIColor.white : UIColor.black, for: .normal)
        
        fridayOutlet.backgroundColor = booleanDays[4] ? UIColor(hexString: color) : UIColor.white
        fridayOutlet.setTitleColor(booleanDays[4] ? UIColor.white : UIColor.black, for: .normal)
        
        saturdayOutlet.backgroundColor = booleanDays[5] ? UIColor(hexString: color) : UIColor.white
        saturdayOutlet.setTitleColor(booleanDays[5] ? UIColor.white : UIColor.black, for: .normal)
        
        sundayOutlet.backgroundColor = booleanDays[6] ? UIColor(hexString: color) : UIColor.white
        sundayOutlet.setTitleColor(booleanDays[6] ? UIColor.white : UIColor.black, for: .normal)
    }
    
    /**
     This method creates the content of the routine with teh given parameters.
     
     - Parameter exercises: The exercises names.
     - Parameter repetitions: The repetitions for every exercise.
     - Parameter series: The series for every exercise.
     - Parameter load: The load or time an exercise has.
     - Author: Aarón Granado Amores.
     */
    func setExercises(exercises:[String], repetitions: [String], series: [String], load: [String]) {
        if exercises.count != repetitions.count || exercises.count != series.count || exercises.count != load.count {
            exercisesLabel.text = "Error al cargar los ejercicios"
        } else {
            if exercises[0] == "no exercises" {
                exercisesLabel.text = "No hay ejercicios en la rutina"
            } else {
                var exercisesText = ""
                
                for position in 0...(exercises.count - 1) {
                    exercisesText += exercises[position] + ": "
                    exercisesText += series[position] + "*"
                    exercisesText += repetitions[position] + " (" + load[position] + " KG o seg.)"
                    
                    if position != (exercises.count - 1) {
                        exercisesText += "\n"
                    }
                }
                
                exercisesLabel.text = exercisesText
            }
        }
    }
    
    /**
     This method places the color into the difficulty indicator depending on the routine difficulty selected
     when creatin the routine.
     
     - Parameter difficulty: The difficulty of the routine.
     - Author: Aarón Granado Amores.
     */
    func setColorToDifficultyIndicator(difficulty: String) {
        var colorToSet: UIColor
        
        switch difficulty {
        case "difficult":
            colorToSet = UIColor.init(hexString: cons.difficultyColorOne)
            break
        case "medium":
            colorToSet = UIColor.init(hexString: cons.difficultyColorTwo)
            break
        case "easy":
            colorToSet = UIColor.init(hexString: cons.difficultyColorThree)
            break
        default:
            colorToSet = UIColor.lightGray
        }
        
        difficultyIndicator.tintColor = colorToSet
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditRoutine" {
            let infoVC = segue.destination as! EditRoutineTableViewController
            
            infoVC.currentRoutine = self.localRoutine
        }
    }
}

extension UIColor {
    //MARK: Create custom color from HEX String
    /**
     This convenience creates and sets a color from a HEX String given.
     
     ## Important Notes ##
     1. The **'alpha'** value is optional and it's set to **'1.0' by default**.
     
     - Parameter hexString: The String containing a HEX color.
     - Parameter alpha: The opacity to be set on the view.
     - Author: Aarón Granado Amores.
     */
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
}
