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

class ExercisesViewController: UIViewController {

    //MARK: UI elements connection
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Variables and constants
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
    
    //MARK: IBActions
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        showInputAlert(title: "AÑADIR EJERCICIO")
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
        let alertController = UIAlertController(title: "INFO", message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: Save to CoreData
    func saveExercise() {
        // Check if there's an exercise with the same name before saving
        
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
            showInfoAlert(message: "Todos los campos con (*) son obligatorios")
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

extension ExercisesViewController: UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    //MARK: TableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: "toExerciseInfo", sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let exerciseToDelete = fetchedResultsController.object(at: indexPath) as! Exercise
        
        if exerciseToDelete.isUserCreated == true {
            AppDelegate.context.delete(exerciseToDelete)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        } else {
            showInfoAlert(message: "No puedes eliminar un ejercicio predefinido")
            tableView.reloadData()
        }
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
}
