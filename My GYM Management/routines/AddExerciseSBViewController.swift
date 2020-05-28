//
//  AddExerciseSBViewController.swift
//  My GYM Management
//
//  Created by Aaron Granado Amores on 14/5/20.
//  Copyright © 2020 AlphaDvlpr. All rights reserved.
//

import UIKit
import CoreData

/**
 This protocol connects this alert with the class where it is called.
 
 ## Important Note ##
 1. Both methods are required.
 
 - Author: Aarón Granado Amores.
 */
protocol CustomExerciseAlertDialogDelegate: class {
    /// The cancel button connection
    func cancelButtonPressed()
    
    /**
     This method sends the values typed on the alert dialog to the caller view. On that class this method
     has to be used to placed those values on the correct places.
     
     - Parameter name: The name of the exercise.
     - Parameter series: The series for the exercise.
     - Parameter repetitions: The repetitions for the exercise.
     - Parameter load: The load or time for the exercise.
     - Author: Aarón Granado Amores.
     */
    func addButtonPressed(name: String, series: String, repetitions: String, load: String)
}

class AddExerciseSBViewController: UIViewController {
    
    //MARK: UI Elements connection
    @IBOutlet weak var exerciseNamePicker: UIPickerView!
    @IBOutlet weak var seriesTextField: UITextField!
    @IBOutlet weak var repetittionsTextField: UITextField!
    @IBOutlet weak var loadTextField: UITextField!
    @IBOutlet weak var alertView: UIView!
    
    //MARK: Variables and constants
    var delegate: CustomExerciseAlertDialogDelegate?
    var exercisesNames: [String] = []
    var selectedExercise: String?
    var cons = Constants()
    
    //MARK: Main functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        exerciseNamePicker.delegate = self
        exerciseNamePicker.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadExercisesNames()
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
     This method fetches all the exercises from CoreData and saves its names into a String array to be
     used on the Picker. If there is no exercise on CoreData it adds a predefined String that will tell
     the user to add an exercise or update the app.
     
     - Author: Aarón Granado Amores.
     */
    func loadExercisesNames() {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Exercise")
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        do {
            let result = try AppDelegate.context.fetch(fetchRequest)
            
            if result.count == 0 {
                exercisesNames.append("Añade un ejercicio")
                selectedExercise = "add"
            } else {
                for res in result {
                    exercisesNames.append(res.value(forKey: "name") as! String)
                }
                
                selectedExercise = exercisesNames[0]
            }
        } catch {
            print("Error checking routine")
            exercisesNames.append("Añade un ejercicio")
            selectedExercise = "add"
        }
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
    
    /**
     This method dismisses the alert when the cancel button is pressed.
     
     - Parameter sender: The sender of the action (In this case UIButton).
     - Author: Aarón Granado Amores.
     */
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        delegate?.cancelButtonPressed()
        self.dismiss(animated: true, completion: nil)
    }
    
    /**
     This method calls the 'saveExercise' method.
     
     - Parameter sender: The sender of the action (In this case UIButton).
     - Author: Aarón Granado Amores.
     */
    @IBAction func addButtonPressed(_ sender: UIButton) {
        saveExercise()
    }
    
    //MARK: Add new exercise
    func saveExercise() {
        if selectedExercise != "add" {
            if seriesTextField.text != "" && repetittionsTextField.text != "" && loadTextField.text != "" {
                delegate?.addButtonPressed(name: selectedExercise!, series: seriesTextField.text!, repetitions: repetittionsTextField.text!, load: loadTextField.text!)
                self.dismiss(animated: true, completion: nil)
            } else {
                showInfoAlert(message: cons.allFieldsAreCompulsory)
            }
        } else {
            showInfoAlert(message: cons.userMustAddOrUpdate)
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

extension AddExerciseSBViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return exercisesNames.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return exercisesNames[row]
    }
    
    //MARK: UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedExercise = exercisesNames[row]
    }
}
