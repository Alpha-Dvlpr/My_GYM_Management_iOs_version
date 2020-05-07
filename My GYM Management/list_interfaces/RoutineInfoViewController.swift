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
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var objectiveLabel: UILabel!
    @IBOutlet weak var exercisesLabel: UILabel!
    @IBOutlet weak var musclesLabel: UILabel!
    @IBOutlet weak var isUserCreatedLabel: UILabel!
    @IBOutlet weak var mondayOutlet: UIButton!
    @IBOutlet weak var tuesdayOutlet: UIButton!
    @IBOutlet weak var wednesdayOutlet: UIButton!
    @IBOutlet weak var thursdayOutlet: UIButton!
    @IBOutlet weak var fridayOutlet: UIButton!
    @IBOutlet weak var saturdayOutlet: UIButton!
    @IBOutlet weak var sundayOutlet: UIButton!
    @IBOutlet weak var editRoutineOutlet: UIBarButtonItem!
    
    //MARK: Variables and constants
    var localRoutine: Routine!
    
    //MARK: Main function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
    }
    
    //MARK: IBActions
    
    /**
     This method sets the action for the edit routine button
     
     - Parameter sender: The sender of the action (In this case UIButton).
     - Author: Aarón Granado Amores.
     */
    @IBAction func editRoutinePressed(_ sender: UIBarButtonItem) {
        showInfoAlert(message: "Próximamente")
    }
    
    /**
     This method sets the action for the send routine button
     
     - Parameter sender: The sender of the action (In this case UIButton).
     - Author: Aarón Granado Amores.
     */
    @IBAction func sendRoutinePressed(_ sender: UIBarButtonItem) {
        showInfoAlert(message: "Próximamente")
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
            
            self.title = localRoutine.name?.uppercased()
            infoLabel.text = localRoutine.info ?? "No hay información"
            setColorToDays(days: daysArray, color: localRoutine.color!)
            objectiveLabel.text = localRoutine.objective ?? "No hay ningún objetivo definido para esta rutina"
            setExercises(exercises: exercisesArray, repetitions: repetitionsArray, series: seriesArray, load: loadArray)
            musclesLabel.text = localRoutine.muscles ?? "No hay músculos implicados en esta rutina"
            isUserCreatedLabel.text = String(localRoutine.isUserCreated)
            
            editRoutineOutlet.isEnabled = localRoutine.isUserCreated
            
        } else {
            self.title = "ERROR"
        }
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
        if days.count != 0 {
            for day in days {
                switch day {
                case "MO":
                    mondayOutlet.backgroundColor = UIColor(hexString: color)
                    mondayOutlet.setTitleColor(UIColor.white, for: .normal)
                    break
                case "TU":
                    tuesdayOutlet.backgroundColor = UIColor(hexString: color)
                    tuesdayOutlet.setTitleColor(UIColor.white, for: .normal)
                    break
                case "WE":
                    wednesdayOutlet.backgroundColor = UIColor(hexString: color)
                    wednesdayOutlet.setTitleColor(UIColor.white, for: .normal)
                case "TH":
                    thursdayOutlet.backgroundColor = UIColor(hexString: color)
                    thursdayOutlet.setTitleColor(UIColor.white, for: .normal)
                case "FR":
                    fridayOutlet.backgroundColor = UIColor(hexString: color)
                    fridayOutlet.setTitleColor(UIColor.white, for: .normal)
                case "SA":
                    saturdayOutlet.backgroundColor = UIColor(hexString: color)
                    saturdayOutlet.setTitleColor(UIColor.white, for: .normal)
                case "SU":
                    sundayOutlet.backgroundColor = UIColor(hexString: color)
                    sundayOutlet.setTitleColor(UIColor.white, for: .normal)
                default:
                    break
                }
            }
        }
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
            if exercises.count == 0 {
                exercisesLabel.text = "No hay ejercicios en la rutina"
            } else {
                exercisesLabel.text = "Mostrando el contenido de los ejercicios"
            }
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
