//
//  BMITableViewController.swift
//  My GYM Management
//
//  Created by Aarón on 25/5/20.
//  Copyright © 2020 AlphaDvlpr. All rights reserved.
//

import UIKit
import CoreData

class BMITableViewController: UITableViewController {
    
    //MARK: UI elements connection
    @IBOutlet weak var bmiGraphOutlet: UIBarButtonItem!
    
    //MARK: Variables and constants
    var addBMIDialog: AddBMIDataSBViewController!
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    
    //MARK: Main function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetch()
        tableView.tableFooterView = UIView()
    }
    
    //MARK: Fetch from CoreData
    /**
     This method searches for the Exercises on CoreData and sorts them by ascending name.
     
     - Author: Aarón Granado Amores.
     */
    func fetch() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BMI")
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: AppDelegate.context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    //MARK: IBActions
    @IBAction func addBMIBarButtonPressed(_ sender: UIBarButtonItem) {
        showNewBMIAlertDialog()
    }
    
    //MARK: Dialogs
    
    /**
     This method creates a custom alert for adding a new BMI calculation.
     
     - Author: Aarón Granado Amores.
     */
    func showNewBMIAlertDialog() {
        let storyboard = UIStoryboard(name: "AddBMIDataSB", bundle: nil)
        addBMIDialog = (storyboard.instantiateViewController(withIdentifier: "AddBMICustomDialog") as! AddBMIDataSBViewController)
        
        addBMIDialog.providesPresentationContextTransitionStyle = true
        addBMIDialog.definesPresentationContext = true
        addBMIDialog.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        addBMIDialog.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        addBMIDialog.delegate = self
        
        self.present(addBMIDialog, animated: true, completion: nil)
    }

    // MARK: TableView DataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfCells = fetchedResultsController.sections?[0].numberOfObjects ?? 0
        
        bmiGraphOutlet.isEnabled = numberOfCells <= 1 ? false : true
        
        return numberOfCells
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let bmi = fetchedResultsController.object(at: indexPath) as! BMI
        
        cell.textLabel?.text = "\(bmi.calculatedBMI)"
        cell.detailTextLabel?.text = "\(bmi.date ?? "")"
        
        return cell
    }
 
    //MARK: TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let bmiToDelete = fetchedResultsController.object(at: indexPath) as! BMI
            
            AppDelegate.context.delete(bmiToDelete)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            tableView.reloadData()
        }
    }
}

extension BMITableViewController: CustomBMIAlertDialogDelegate, NSFetchedResultsControllerDelegate {
    //MARK: CustomBMIAlertDialogDelegate
    func cancelButtonPressed() {}
    
    func acceptButtonPressed(age: Int, height: Double, weight: Double, sex: String) {
        let bmi = BMI(context: AppDelegate.context)
        let currentDate = NSDate()
        let dateFormatter = DateFormatter()
        let heightInMeters: Double = height / 100
        let squaredHeight: Double = heightInMeters * heightInMeters
        
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        
        bmi.age = Int64(age)
        bmi.height = height
        bmi.gender = sex
        bmi.weight = weight
        bmi.date = dateFormatter.string(from: currentDate as Date)
        bmi.calculatedBMI = Double(String(format: "%.2f", (weight / squaredHeight)))!
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        tableView.reloadData()
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
