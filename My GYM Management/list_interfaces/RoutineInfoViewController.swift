//
//  RoutineInfoViewController.swift
//  My GYM Management
//
//  Created by Aaron Granado Amores on 7/5/20.
//  Copyright © 2020 AlphaDvlpr. All rights reserved.
//

import UIKit

class RoutineInfoViewController: UIViewController {

    //MARK: UI Elements connection
    
    //MARK: Variables and constants
    var localRoutine: Routine!
    
    //MARK: Main function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if localRoutine != nil {
            self.title = localRoutine.name?.uppercased()
        } else {
            self.title = "ERROR"
        }
    }
    
    //MARK: IBActions
}
