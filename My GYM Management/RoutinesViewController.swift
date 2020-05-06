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
    @IBAction func loseWeightButtonPressed(_ sender: UIButton) {
        objective = "loseWeight"
        perform()
    }
    
    @IBAction func gainMuscleButtonPressed(_ sender: UIButton) {
        objective = "gainMuscle"
        perform()
    }
    
    @IBAction func defineMuscleButtonPressed(_ sender: UIButton) {
        objective = "defineMuscle"
        perform()
    }
    
    //MARK: Navigation
    func perform() {
        performSegue(withIdentifier: "toMuscleGroupSelector", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMuscleGroupSelector" {
            let muscleSelectorVC = segue.destination as! MuscleGroupSelectorViewController
            
            muscleSelectorVC.objective = objective
        }
    }
}
