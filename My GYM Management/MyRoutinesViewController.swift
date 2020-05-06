//
//  MyRoutinesViewController.swift
//  My GYM Management
//
//  Created by Aaron Granado Amores on 6/4/20.
//  Copyright © 2020 AlphaDvlpr. All rights reserved.
//

import UIKit
import MessageUI
import CoreData

class MyRoutinesViewController: UIViewController {
    
    //MARK: UI elements connection
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Variables and constants
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    var nameTextField: UITextField!
    var descriptionTextField: UITextField!
    
    //MARK: Main function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Routine")
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        // Show only the ones with 'isUserCreated' as true
        
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
        showNewRoutineDialog(title: "AÑADIR RUTINA")
    }
    
    //MARK: Alerts
    func showNewRoutineDialog(title: String) {
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        alertController.addTextField { (_nameTextField) in
            _nameTextField.placeholder = "Nombre (*)"
            self.nameTextField = _nameTextField
        }
        
        alertController.addTextField { (_descriptionTextField) in
            _descriptionTextField.placeholder = "Descripción"
            self.descriptionTextField = _descriptionTextField
        }
        
        // Color checker
        
        // Days checker
        
        alertController.addAction(UIAlertAction(title: "Cancelar", style: .destructive, handler: nil))
        alertController.addAction(UIAlertAction(title: "Añadir", style: .default, handler: { (alert) in self.saveRoutine() }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showInfoAlert(message: String) {
        let alertController = UIAlertController(title: "INFO", message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
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
        } else {
            showInfoAlert(message: "Todos los campos con (*) son obligatorios")
        }
    }
    
    func saveToCD() {
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRoutineInfo" {
            //let indexPath = sender as! IndexPath
            //let infoVC = segue.destination as! RoutineInfoViewController
            //let routine = fetchedResultsController.object(at: indexPath) as! Routine
            
            //infoVC.localRoutine = routine
        }
    }
}

extension MyRoutinesViewController: UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    //MARK: TableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: "toRoutineInfo", sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let routineToDelete = fetchedResultsController.object(at: indexPath) as! Routine
        
        if routineToDelete.isUserCreated == true {
            AppDelegate.context.delete(routineToDelete)
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
        let exercise = fetchedResultsController.object(at: indexPath) as! Routine
        
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
