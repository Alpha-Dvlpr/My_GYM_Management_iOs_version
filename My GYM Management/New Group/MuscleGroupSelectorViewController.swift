//
//  MuscleGroupSelectorViewController.swift
//  My GYM Management
//
//  Created by Aaron Granado Amores on 14/4/20.
//  Copyright © 2020 AlphaDvlpr. All rights reserved.
//

import UIKit

class MuscleGroupSelectorViewController: UIViewController {

    //MARK: Variables and constants
    var objective: String!
    var group: String!
    
    //MARK: Main function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
    }
    
    //MARK: IBActions
    
    /**
     This method sets the value of **'group'** and performs the segur to the next view.
     
     - Parameter sender: The sender of the action (In this case UIButton).
     - Author: Aarón Granado Amores.
     */
    @IBAction func upperPartButtonSelected(_ sender: UIButton) {
        group = "upperPart"
        perform()
    }
    
    /**
     This method sets the value of **'group'** and performs the segur to the next view.
     
     - Parameter sender: The sender of the action (In this case UIButton).
     - Author: Aarón Granado Amores.
     */
    @IBAction func lowerPartButtonSelected(_ sender: UIButton) {
        group = "lowerPart"
        perform()
    }
    
    /**
     This method sets the value of **'group'** and performs the segur to the next view.
     
     - Parameter sender: The sender of the action (In this case UIButton).
     - Author: Aarón Granado Amores.
     */
    @IBAction func coreButtonSelected(_ sender: UIButton) {
        group = "core"
        perform()
    }
    
    //MARK: Update UI
    
    /**
     This method set all the values on the view. This depends on the values received from the previous segue.
     
     - Author: Aarón Granado Amores.
     */
    func updateUI() {
        var titleToSet: String
        
        switch objective {
        case "loseWeight":
            titleToSet = "perder peso"
            break
        case "gainMuscle":
            titleToSet = "ganar masa"
            break
        case "defineMuscle":
            titleToSet = "definir"
            break
        default:
            titleToSet = "no title"
        }
        
        self.title = titleToSet.uppercased()
    }
    
    //MARK: Navigation
    
    /**
     This method creates the segue to the list of predefined routines.
     
     - Author: Aarón Granado Amores.
     */
    func perform() {
        performSegue(withIdentifier: "toRoutinesList", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRoutinesList" {
            let routineSelectorVC = segue.destination as! RoutinesListViewController
            
            routineSelectorVC.objective = objective
            routineSelectorVC.group = group
        }
    }
}
