//
//  RoutinesListViewController.swift
//  My GYM Management
//
//  Created by Aaron Granado Amores on 14/4/20.
//  Copyright © 2020 AlphaDvlpr. All rights reserved.
//

import UIKit

class RoutinesListViewController: UIViewController {

    //MARK: UI elements connection
    
    //MARK: Variables and constants
    var objective: String!
    
    //MARK: Main function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
    }
    
    //MARK: Update UI
    
    /**
     This method sets the values on the view. Those values are set on the previous segue.
     
     - Author: Aarón Granado Amores.
     */
    func updateUI() {
        var viewTitle: String = ""
        
        switch objective {
        case "loseWeight":
            viewTitle = "PERDER PESO"
            break
        case "gainMuscle":
            viewTitle = "GANAR MASA"
            break
        case "defineMuscle":
            viewTitle = "DEFINIR"
            break
        default:
            viewTitle = "ERROR"
        }
        
        self.title = viewTitle
    }
}
