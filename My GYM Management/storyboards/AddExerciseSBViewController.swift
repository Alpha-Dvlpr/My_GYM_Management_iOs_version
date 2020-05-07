//
//  AddExerciseSBViewController.swift
//  My GYM Management
//
//  Created by Aaron Granado Amores on 7/5/20.
//  Copyright © 2020 AlphaDvlpr. All rights reserved.
//

import UIKit

protocol CustomExerciseAlertDialogDelegate: class {
    func cancelButtonPressed()
    func addButtonPressed()
}

class AddExerciseSBViewController: UIViewController {
    
    //MARK: UI Elements connection
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var infoTextField: UITextField!
    @IBOutlet weak var executionTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var musclesTextField: UITextField!
    @IBOutlet weak var alertView: UIView!
    
    //MARK: Variables and constants
    var delegate: CustomExerciseAlertDialogDelegate?
    
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
        saveExercise()
    }
    
    //MARK: Save to CD
    func saveExercise() {
        // Check if there's an exercise with the same name.
        
        if nameTextField.text != "" && infoTextField.text != "" && executionTextField.text != "" {
            let exerciseToSave: Exercise = Exercise(context: AppDelegate.context)
            
            exerciseToSave.name = nameTextField.text
            exerciseToSave.info = infoTextField.text
            exerciseToSave.execution = executionTextField.text
            exerciseToSave.isUserCreated = true
            
            if linkTextField.text != "" { exerciseToSave.link = linkTextField.text }
            if musclesTextField.text != "" { exerciseToSave.muscles = musclesTextField.text }
            
            saveToCD()
            self.dismiss(animated: true, completion: nil)
        } else {
            showInfoAlert(message: "Todos los campos con '*' son obligatorios")
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
