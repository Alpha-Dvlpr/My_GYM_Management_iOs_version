//
//  RoutinesListViewController.swift
//  My GYM Management
//
//  Created by Aaron Granado Amores on 14/4/20.
//  Copyright © 2020 AlphaDvlpr. All rights reserved.
//

import UIKit
import CoreData

class RoutinesListViewController: UIViewController {

    //MARK: UI elements connection
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Variables and constants
    var objective: String!
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    
    //MARK: Main function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
        fetch()
        tableView.tableFooterView = UIView()
    }
    
    //MARK: Update UI
    
    /**
     This method sets the values on the view. Those values are set on the previous segue.
     
     - Author: Aarón Granado Amores.
     */
    func updateUI() {
        var viewTitle: String = ""
        
        switch objective {
        case "loseWeight":
            viewTitle = "PERDER PESO"
            break
        case "gainMuscle":
            viewTitle = "GANAR MASA"
            break
        case "defineMuscle":
            viewTitle = "DEFINIR"
            break
        default:
            viewTitle = "ERROR"
        }
        
        self.title = viewTitle
    }
    
    //MARK: Fetch from CoreData
    
    /**
     This method searches for the Routines on CoreData and sorts them by ascending name.
     
     ## Important Notes ##
     1. This method only searches for Routines that have **'isUserCreated'** set as **'false'**.
     
     - Author: Aarón Granado Amores.
     */
    func fetch() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Routine")
        let predicate = NSCompoundPredicate(format: "isUserCreated == %@ AND objective == %@", NSNumber(value: false), objective)
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        fetchRequest.predicate = predicate
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: AppDelegate.context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRoutineInfo" {
            let indexPath = sender as! IndexPath
            let infoVC = segue.destination as! RoutineInfoViewController
            let routine = fetchedResultsController.object(at: indexPath) as! Routine
            
            infoVC.localRoutine = routine
        }
    }
}

extension RoutinesListViewController: UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    //MARK: TableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: "toRoutineInfo", sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    //MARK: TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[0].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let routine = fetchedResultsController.object(at: indexPath) as! Routine
        
        cell.textLabel?.text = routine.name
        
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
