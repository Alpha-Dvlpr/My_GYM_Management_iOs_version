//
//  ExercisesViewController.swift
//  My GYM Management
//
//  Created by Aaron Granado Amores on 6/4/20.
//  Copyright © 2020 AlphaDvlpr. All rights reserved.
//

import UIKit
import MessageUI
import CoreData

class ExercisesViewController: UIViewController, MFMailComposeViewControllerDelegate, NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource {

    //MARK: UI elements connection
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Variables and constants
    var cons = Constants()
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    var nameTextField: UITextField!
    var infoTextField: UITextField!
    var executionTextField: UITextField!
    var linkTextField: UITextField!
    var musclesTextField: UITextField!
    
    //MARK: Main function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Exercise")
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: AppDelegate.context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
        
        tableView.tableFooterView = UIView()
    }
    
    //MARK: Email Delegate
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
    
    //MARK: TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[0].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let exercise = fetchedResultsController.object(at: indexPath) as! Exercise
        
        cell.textLabel?.text = exercise.name
        
        return cell
    }
    
    //MARK: TableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: "toExerciseInfo", sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let contactToDelete = fetchedResultsController.object(at: indexPath) as! Exercise
        
        if contactToDelete.isUserCreated == true {
            AppDelegate.context.delete(contactToDelete)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        } else {
            showInfoAlert(message: "No puedes eliminar un ejercicio predefinido")
            tableView.reloadData()
        }
    }
    
    //MARK: NSFetchedResultsControllerDelegate
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
            break
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
            break
        default:
            print("Unknown type")
        }
    }
    
    //MARK: IBActions
    @IBAction func privacyButtonPressed(_ sender: UIBarButtonItem) {
        guard let privacyURL = URL(string: cons.privacyURL) else { return }
        
        UIApplication.shared.open(privacyURL)
    }
    
    @IBAction func contactButtonPressed(_ sender: UIBarButtonItem) {
        showMailcomposer()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        showInputAlert(title: "Añadir ejercicio")
    }
    
    //MARK: Helpers
    func showMailcomposer() {
        guard MFMailComposeViewController.canSendMail() else { return }
        let composer = MFMailComposeViewController()
        
        composer.mailComposeDelegate = self
        composer.setToRecipients(cons.emailAddresses)
        composer.setSubject(cons.emailSubject)
        composer.setMessageBody(cons.emailBody, isHTML: false)
        
        present(composer, animated: true)
    }
    
    
    //MARK: Alerts
    func showInputAlert(title: String) {
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        alertController.addTextField { (_nameTextField) in
            _nameTextField.placeholder = "Nombre (*)"
            self.nameTextField = _nameTextField
        }
        
        alertController.addTextField { (_infoTextField) in
            _infoTextField.placeholder = "Información (*)"
            self.infoTextField = _infoTextField
        }
        
        alertController.addTextField { (_executionTextField) in
            _executionTextField.placeholder = "Ejecución (*)"
            self.executionTextField = _executionTextField
        }
        
        alertController.addTextField { (_linkTextField) in
            _linkTextField.placeholder = "Enlace a YouTube"
            self.linkTextField = _linkTextField
        }
        
        alertController.addTextField { (_musclesTextField) in
            _musclesTextField.placeholder = "Músculos"
            self.musclesTextField = _musclesTextField
        }
        
        alertController.addAction(UIAlertAction(title: "Cancelar", style: .destructive, handler: nil))
        alertController.addAction(UIAlertAction(title: "Añadir", style: .default, handler: { (alert) in self.saveExercise() }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showInfoAlert(message: String) {
        let alertController = UIAlertController(title: "Info", message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: Save to CoreData
    func saveExercise() {
        if nameTextField.text != "" && infoTextField.text != "" && executionTextField.text != "" {
            let exercise = Exercise(context: AppDelegate.context)
            
            exercise.name = nameTextField.text
            exercise.info = infoTextField.text
            exercise.execution = executionTextField.text
            exercise.isUserCreated = true
            if linkTextField.text != "" { exercise.link = linkTextField.text }
            if musclesTextField.text != "" { exercise.muscles = musclesTextField.text }
            
            saveToCD()
        } else {
            print("All fields are required")
        }
    }
    
    func saveToCD() {
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toExerciseInfo" {
            let indexPath = sender as! IndexPath
            let infoVC = segue.destination as! ExerciseInfoViewController
            let exercise = fetchedResultsController.object(at: indexPath) as! Exercise
            
            infoVC.localExercise = exercise
        }
    }
}
