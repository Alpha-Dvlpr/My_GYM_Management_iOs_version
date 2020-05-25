//
//  AddBMIDataSBViewController.swift
//  My GYM Management
//
//  Created by Aarón on 25/5/20.
//  Copyright © 2020 AlphaDvlpr. All rights reserved.
//

import UIKit
import DLRadioButton

/**
 This protocol connects this alert with the class where it is called.
 
 ## Important Note ##
 1. Both methods are required.
 
 - Author: Aarón Granado Amores.
 */
protocol CustomBMIAlertDialogDelegate: class {
    /// The cancel button action.
    func cancelButtonPressed()
    
    
    /**
     This method sends the values typed on the alert dialog to the caller view. On that class this method
     has to be used to placed those values on the correct places.
     
     - Parameter age: The user's age.
     - Parameter height: The user's height.
     - Parameter weight: The user's weight.
     - Parameter sex: The user's gender.
     - Author: Aarón Granado Amores.
     */
    func acceptButtonPressed(age: Int, height: Double, weight: Double, sex: String)
}

class AddBMIDataSBViewController: UIViewController {

    //MARK: UI elements connection
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var maleRadioButton: DLRadioButton!
    @IBOutlet weak var femaleRadioButton: DLRadioButton!
    @IBOutlet weak var alertView: UIView!

    //MARK: Variables and constants
    var delegate: CustomBMIAlertDialogDelegate?
    
    //MARK: Main functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ageTextField.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setupView()
        animateView()
    }
    
    //MARK: Helpers
    /**
     This function setups the AlertView to have rounded corners and sets the view's background to imitate system
     AlertController.
     
     - Author: Aarón Granado Amores.
     */
    func setupView() {
        alertView.layer.cornerRadius = 15
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    /**
     This function animates the AlertController when appearing.
     
     - Author: Aarón Granado Amores.
     */
    func animateView() {
        alertView.alpha = 0;
        self.alertView.frame.origin.y = self.alertView.frame.origin.y + 50
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.alertView.alpha = 1.0;
            self.alertView.frame.origin.y = self.alertView.frame.origin.y - 50
        })
    }
    
    /**
     This method handles the keyboard events, updating the alert constraints when the keyboard is opened.
     
     - Parameter notification: The notification launched when the keyboard state changes (In this case when
     it's opened).
     - Author: Aarón Granado Amores.
     */
    @objc func handleKeyboardNotification(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            updateExerciseAlertConstraints(offsetHeight: keyboardHeight)
        }
    }
    
    /**
     This method sets new constraints to the dialog when the keyboard is open in order to center it on the
     free space on the screeen.
     
     - Parameter offsetHeight: The value to be added on the bottom constraint, this is given by the keyboard height.
     - Author: Aarón Granado Amores.
     */
    public func updateExerciseAlertConstraints(offsetHeight: CGFloat) {
        let viewHeight: CGFloat = alertView.bounds.height
        let screenHeight: CGFloat = UIScreen.main.bounds.height
        let freeSpace: CGFloat = screenHeight - offsetHeight - viewHeight
        let constraint: CGFloat = freeSpace / 2
        
        alertView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: constraint).isActive = true
        alertView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -(constraint + offsetHeight)).isActive = true
    }
    
    //MARK: IBActions
    @IBAction func deselectRadioButton(_ sender: DLRadioButton) {
        if sender == maleRadioButton {
            femaleRadioButton.isSelected = false
        }
        
        if sender == femaleRadioButton {
            maleRadioButton.isSelected = false
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        delegate?.cancelButtonPressed()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func acceptButtonPressed(_ sender: UIButton) {
        saveBMI()
    }
    
    //MARK: Save BMI
    func saveBMI() {
        if ageTextField.text != "" && heightTextField.text != "" && weightTextField.text != "" {
            if !maleRadioButton.isSelected && !femaleRadioButton.isSelected {
                showInfoAlert(message: "Debes seleccionar un género")
            } else {
                delegate?.acceptButtonPressed(age: Int(ageTextField.text!)!,
                                              height: Double(heightTextField.text!)!,
                                              weight: Double(weightTextField.text!)!,
                                              sex: maleRadioButton.isSelected ? "male" : "female")
                self.dismiss(animated: true, completion: nil)
            }
        } else {
            showInfoAlert(message: "Debes completar toda la información")
        }
    }
    
    //MARK: AlertDialog
    
    /**
     This method shows an Alert with the given message.
     
     - Parameter message: The message to be displayed.
     - Author: Aarón Granado Amores.
     */
    func showInfoAlert(message: String) {
        let alertController = UIAlertController(title: "INFO", message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
}
