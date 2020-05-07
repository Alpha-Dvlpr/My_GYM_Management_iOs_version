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
    @IBOutlet weak var label: UILabel!
    
    //MARK: Variables and constants
    var objective: String!
    var group: String!
    
    //MARK: Main function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
    }
    
    //MARK: Update UI
    func updateUI() {
        label.text = "Objective: " + objective + "\nGroup: " + group
    }
}
