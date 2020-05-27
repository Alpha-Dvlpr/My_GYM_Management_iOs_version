//
//  RoutinesViewController.swift
//  My GYM Management
//
//  Created by Aaron Granado Amores on 6/4/20.
//  Copyright © 2020 AlphaDvlpr. All rights reserved.
//

import UIKit
import MessageUI

class RoutinesViewController: UIViewController {

    //MARK: Variables and constants
    var objective: String!
    
    //MARK: Main function
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: IBActions
    
    /**
     This method sets the action for the lose weight button.
     
     - Parameter sender: The sender of the action (In this case UIButton).
     - Author: Aarón Granado Amores.
     */
    @IBAction func loseWeightButtonPressed(_ sender: UIButton) {
        objective = "loseWeight"
        perform()
    }
    
    /**
     This method sets the action for the gain muscle button.
     
     - Parameter sender: The sender of the action (In this case UIButton).
     - Author: Aarón Granado Amores.
     */
    @IBAction func gainMuscleButtonPressed(_ sender: UIButton) {
        objective = "gainMuscle"
        perform()
    }
    
    /**
     This method sets the action for the define muscle button.
     
     - Parameter sender: The sender of the action (In this case UIButton).
     - Author: Aarón Granado Amores.
     */
    @IBAction func defineMuscleButtonPressed(_ sender: UIButton) {
        objective = "defineMuscle"
        perform()
    }
    
    //MARK: Navigation
    
    /**
     This method creates the segue next view.
     
     - Author: Aarón Granado Amores.
     */
    func perform() {
        performSegue(withIdentifier: "toRoutines", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRoutines" {
            let routineListVC = segue.destination as! RoutinesListViewController
            
            routineListVC.objective = objective
        }
    }
}
