//
//  OthersViewController.swift
//  My GYM Management
//
//  Created by Aaron Granado Amores on 6/4/20.
//  Copyright © 2020 AlphaDvlpr. All rights reserved.
//

import UIKit
import MessageUI
import FirebaseFirestore
import CoreData

class OthersViewController: UIViewController {

    //MARK: Variables and constants
    var cons = Constants()
    let database = Firestore.firestore()
    
    //MARK: Main function
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: IBActions
    
    /**
      This method sets the action for the privacy button.
     
     - Parameter sender: The sender of the action (In this case uIButton).
     - Author: Aarón Granado Amores.
     */
    @IBAction func privacyButtonPressed(_ sender: UIButton) {
        guard let privacyURL = URL(string: cons.privacyURL) else { return }
        
        UIApplication.shared.open(privacyURL)
    }
    
    /**
     This method sets the action for the contact button.
     
     - Parameter sender: The sender of the action (In this case uIButton).
     - Author: Aarón Granado Amores.
     */
    @IBAction func contactButtonPressed(_ sender: UIButton) {
        showMailcomposer()
    }
    
    /**
     This method sets the action for the gym locator button.
     
     - Parameter sender: The sender of the action (In this case uIButton).
     - Author: Aarón Granado Amores.
     */
    @IBAction func locateGymButtonPressed(_ sender: UIButton) {
        openAppleMaps()
    }
    
    /**
     This method sets the action for the update button.
     
     - Parameter sender: The sender of the action (In this case uIButton).
     - Author: Aarón Granado Amores.
     */
    @IBAction func updateDataButtonPressed(_ sender: UIButton) {
        fetchFromFirebase()
    }
    
    //MARK: Helpers
    
    /**
     This method sets all the values to be placed on the email.
    
     - Author: Aarón Granado Amores.
     */
    func showMailcomposer() {
        guard MFMailComposeViewController.canSendMail() else { return }
        let composer = MFMailComposeViewController()
        
        composer.mailComposeDelegate = self
        composer.setToRecipients(cons.emailAddresses)
        composer.setSubject(cons.emailSubject)
        composer.setMessageBody(cons.emailBody, isHTML: false)
        
        present(composer, animated: true)
    }
    
    /**
     This method opens Apple Maps if it is available on the user's device to show the locatin near gyms URL.
     
     - Author: Aarón Granado Amores.
     */
    func openAppleMaps() {
        if (UIApplication.shared.canOpenURL(URL(string:"http://maps.apple.com")!)) {
            UIApplication.shared.open(URL(string: cons.appleMapsURL)!)
        } else {
            NSLog("Can't use Apple Maps");
        }
    }
    
    /**
     This method searches on Firebase for all the data and the saves or updates the values stored on CoreData.

     - Author: Aarón Granado Amores.
     */
    func fetchFromFirebase() {
        let updateDialog = UIAlertController(title: "ACTUALIZANDO", message: self.cons.firebaseUpdatingMessage, preferredStyle: .alert)
        
        self.present(updateDialog, animated: true, completion: nil)
        
        database.collection("exercises").getDocuments { (snapshot, error) in
            if error != nil {
                self.showInfoAlert(message: self.cons.firebaseErrorMessage)
            } else {
                for document in (snapshot?.documents)! {
                    let name = document.data()["name"] as! String
                    let exercise = !self.checkIfExerciseExistsOnCoreData(name: name) ?
                        Exercise(context: AppDelegate.context) : self.getExerciseFromCoreData(name: name)
                    
                    exercise.execution = document.data()["execution"] as? String
                    exercise.info = document.data()["info"] as? String
                    exercise.isUserCreated = false
                    exercise.link = document.data()["link"] as? String
                    exercise.muscles = document.data()["muscles"] as? String
                    exercise.name = name
                   
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                }
            }
        }
        
        database.collection("routines").getDocuments { (snapshot, error) in
            if error != nil {
                self.showInfoAlert(message: self.cons.firebaseErrorMessage)
            } else {
                for document in (snapshot?.documents)! {
                    let name = document.data()["name"] as! String
                    let routine = !self.checkIfRoutineExistsOnCoreData(name: name) ?
                        Routine(context: AppDelegate.context) : self.getRoutineFromCoreData(name: name)
                    
                    routine.color = document.data()["color"] as? String
                    routine.days = document.data()["days"] as? String
                    routine.difficulty = document.data()["difficulty"] as? String
                    routine.exercises = document.data()["exercises"] as? String
                    routine.info = document.data()["info"] as? String
                    routine.isUserCreated = false
                    routine.load = document.data()["load"] as? String
                    routine.muscles = document.data()["muscles"] as? String
                    routine.name = name
                    routine.objective = document.data()["objective"] as? String
                    routine.repetitions = document.data()["repetitions"] as? String
                    routine.series = document.data()["series"] as? String
                    
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                }
            }
        }
        
        updateDialog.dismiss(animated: true, completion: nil)
    }
    
    /**
     This method checks if there is an exercise with the same name on Core Data.
     
     - Parameter name: The name of the execrise to be checked.
     - Returns: Returns **true** if the exercise already exists and **false** if not.
     - Author: Aarón Granado Amores.
     */
    func checkIfExerciseExistsOnCoreData(name: String) -> Bool{
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Exercise")
        
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        do {
            let result = try AppDelegate.context.fetch(fetchRequest)
            
            if result.count != 0 {
                return true
            }
        } catch {
            print("Error checking exercise")
            return true
        }
        
        return false
    }
    
    
    /**
     This method gets the exercise with the given name from CoreData to update is values if it exists.
     
     - Parameter name: The name of the exercise to be searched.
     - Returns: Returns the exercise if it exists. If not it returns an empty exercise.
     - Author: Aarón Granado Amores.
     */
    func getExerciseFromCoreData(name: String) -> Exercise {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Exercise")
        
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        do {
            let result = try AppDelegate.context.fetch(fetchRequest)
            
            if result.count == 1{
                return result[0] as! Exercise
            } else {
                return Exercise()
            }
        } catch {
            print("Error getting exercise from CoreData")
            return Exercise()
        }
    }
    
    /**
     This method checks if there is a routine with the same name on Core Data.
     
     - Parameter name: The name of the routine to be checked.
     - Returns: Returns **true** if the routine already exists and  **false** if not.
     - Author: Aarón Granado Amores.
     */
    func checkIfRoutineExistsOnCoreData(name: String) -> Bool{
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Routine")
        
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        do {
            let result = try AppDelegate.context.fetch(fetchRequest)
            
            if result.count != 0 {
                return true
            }
        } catch {
            print("Error checking routine")
            return true
        }
        
        return false
    }
    
    /**
     This method gets the routine with the given name from CoreData to update is values if it exists.
     
     - Parameter name: The name of the routine to be searched.
     - Returns: Returns the routine if it exists. If not it returns an empty routine.
     - Author: Aarón Granado Amores.
     */
    func getRoutineFromCoreData(name: String) -> Routine {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Routine")
        
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        do {
            let result = try AppDelegate.context.fetch(fetchRequest)
            
            if result.count == 1{
                return result[0] as! Routine
            } else {
                return Routine()
            }
        } catch {
            print("Error getting routine from CoreData")
            return Routine()
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

extension OthersViewController: MFMailComposeViewControllerDelegate{
    //MARK: MailComposer Delegate
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let _ = error {
            controller.dismiss(animated: true)
            return
        }
        
        switch result {
        case .cancelled:
            print("Email cancelled")
            break
        case .failed:
            print("Email failed")
            break
        case .saved:
            print("Email saved")
            break
        case .sent:
            print("Email sent")
            break
        }
        
        controller.dismiss(animated: true)
    }
}
