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
    
    //MARK: Main function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetch()
        tableView.tableFooterView = UIView()
    }
    
    /**
     This method searches for the Exercises on CoreData and sorts them by ascending name.
     
     - Author: Aarón Granado Amores.
     */
    func fetch() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Exercise")
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: AppDelegate.context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    //MARK: IBActions
    
    /**
     The action for the add button.
     
     - Parameter sender: The sender of the action (In this case UIButton).
     - Author: Aarón Granado Amores.
     */
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        showNewExerciseDialog()
    }
    
    //MARK: Alerts
    
    /**
     This method creates a custom alert for adding a new exercise to CoreData.
     
     - Author: Aarón Granado Amores.
     */
    func showNewExerciseDialog() {
        let storyboard = UIStoryboard(name: "AddExercise", bundle: nil)
        let addExerciseDialog = storyboard.instantiateViewController(withIdentifier: "AddExerciseCustomDialog") as! AddExerciseSBViewController
        
        addExerciseDialog.providesPresentationContextTransitionStyle = true
        addExerciseDialog.definesPresentationContext = true
        addExerciseDialog.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        addExerciseDialog.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        addExerciseDialog.delegate = self
        
        self.present(addExerciseDialog, animated: true, completion: nil)
    }
    
    /**
     This method shows an alert with the message given.
     
     - Parameter message: The message to be displayed.
     - Author: Aarón Granado Amores.
     */
    func showInfoAlert(message: String) {
        let alertController = UIAlertController(title: "INFO", message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
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

extension ExercisesViewController: UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, CustomExerciseAlertDialogDelegate {
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
    
    //MARK: CustomAlertDialogDelegate
    func cancelButtonPressed() {}
    
    func addButtonPressed() {}
}
