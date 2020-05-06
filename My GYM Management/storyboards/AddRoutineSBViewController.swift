//
//  AddRoutineSBViewController.swift
//  My GYM Management
//
//  Created by Aaron Granado Amores on 6/5/20.
//  Copyright © 2020 AlphaDvlpr. All rights reserved.
//

import UIKit
import DLRadioButton

protocol CustomAlertDialogDelegate: class {
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
    
    //MARK: Variables and constants
    var delegate: CustomAlertDialogDelegate?
    
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
    
    //MARK: Save to CD
    func saveRoutine() {
        // Check if there's a routine with the same name.
        
        if nameTextField.text != "" {
            let routineToSave = Routine(context: AppDelegate.context)
            
            routineToSave.name = nameTextField.text
            routineToSave.isUserCreated = true
            
            if descriptionTextField.text != "" { routineToSave.info = descriptionTextField.text }
            
            saveToCD()
            self.dismiss(animated: true, completion: nil)
        } else {
            showInfoAlert(message: "Todos los campos con (*) son obligatorios")
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
