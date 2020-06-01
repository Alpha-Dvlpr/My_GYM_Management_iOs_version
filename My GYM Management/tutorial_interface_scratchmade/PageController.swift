//
//  PageController.swift
//  My GYM Management
//
//  Created by Aaron Granado Amores on 8/5/20.
//  Copyright © 2020 AlphaDvlpr. All rights reserved.
//

import UIKit
import CoreData
import FirebaseFirestore

class PageController: UICollectionViewController {
    
    //MARK: Variables and constants
    private var bottomStack: UIStackView!
    let cons = Constants()
    let database = Firestore.firestore()
    
    /**
     This array holds all the pages that will be displayed on the introductory page controller
     
     - Author: Aarón Granado Amores.
     */
    var pages: [Page] = []
    
    //MARK: Main function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createPages()
        addViewsToLayout()
        
        collectionView.backgroundColor = UIColor(red: 179/255, green: 248/255, blue: 255/255, alpha: 1)
        collectionView.register(PageCell.self, forCellWithReuseIdentifier: "cellID")
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
    }
    
    //MARK: Pages creation
    
    /**
     This method fills the pages array with severas new pages depending on the values on the Constants.swift file.
     
     - Author: Aarón Granado Amores.
     */
    func createPages() {
        let numberOfPages = cons.titles.count - 1
        
        for i in 0...numberOfPages {
            let pageToAdd = Page(titleText: cons.titles[i], descriptionText: cons.descriptions[i])
            
            pages.append(pageToAdd)
        }
    }
    
    //MARK: Layout setup
    
    /**
     This method adds the custom views to the current layout. It also sets the basic attributes to the stack view.
     
     - Author: Aarón Granado Amores.
     */
    func addViewsToLayout() {
        bottomStack = UIStackView(arrangedSubviews: [prevButton, pageControl, nextButton])
        
        bottomStack.translatesAutoresizingMaskIntoConstraints = false
        bottomStack.distribution = .fillEqually
        bottomStack.axis = .horizontal
        bottomStack.spacing = 21
        
        view.addSubview(bottomStack)
        view.addSubview(skipButton)
        
        setupConstraints()
    }
    
    /**
     This method adds all the constraints to the custom views.
     
     - Author: Aarón Granado Amores.
     */
    func setupConstraints() {
        bottomStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        bottomStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        bottomStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        
        skipButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24).isActive = true
        skipButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
    }
    
    //MARK: UI Elements
    
    /**
     Custom button for going forward on the page controller.
     
     - Author: Aarón Granado Amores.
     */
    private let prevButton: UIButton = {
        let button = UIButton()
        let attributedTitle = NSMutableAttributedString(string: "ANTERIOR", attributes: [
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15),
            NSAttributedString.Key.foregroundColor : UIColor.darkGray]
        )
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handlePrev), for: .touchUpInside)
        
        return button
    }()
    
    /**
     Custom button for going backwards on the page controller.
     
     - Author: Aarón Granado Amores.
     */
    private let nextButton: UIButton = {
        let button = UIButton()
        let attributedTitle = NSMutableAttributedString(string: "SIGUIENTE", attributes:
            [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15),
             NSAttributedString.Key.foregroundColor : UIColor.blue]
        )
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        
        return button
    }()
    
    /**
     Custom button for skipping the intro page controller.
     
     - Author: Aarón Granado Amores.
     */
    private let skipButton: UIButton = {
        let button = UIButton()
        let attributedTitle = NSMutableAttributedString(string: "OMITIR", attributes:
            [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),
             NSAttributedString.Key.foregroundColor : UIColor.red]
        )
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleSkip), for: .touchUpInside)
        
        return button
    }()
    
    /**
     Custom page controller for showing the user what is the current page.
     
     - Author: Aarón Granado Amores.
     */
    private lazy var pageControl: UIPageControl = {
        let control = UIPageControl()
        
        control.currentPage = 0
        control.numberOfPages = pages.count
        control.currentPageIndicatorTintColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
        control.pageIndicatorTintColor = UIColor(red: 118/255, green: 214/255, blue: 255/255, alpha: 1)
        
        return control
    }()
    
    //MARK: IBActions
    
    /**
     This method handles the event caused by the next button press action. This makes the page controller
     go one page forward. If the current page is the last one it performs a segue to the main page.
     
     - Author: Aarón Granado Amores.
     */
    @objc private func handleNext() {
        let nextIndex = min(pageControl.currentPage + 1, pages.count - 1)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        
        if pageControl.currentPage == pages.count - 1 {
            showInfoAlert(message: cons.updateAlertMessage)
        }
        
        pageControl.currentPage = nextIndex
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    /**
     This method handles the event caused by the prev button press action. This makes the page controller
     go one page backwards until the first one.
     
     - Author: Aarón Granado Amores.
     */
    @objc private func handlePrev() {
        let prevIndex = max(pageControl.currentPage - 1, 0)
        let indexPath = IndexPath(item: prevIndex, section: 0)
        
        pageControl.currentPage = prevIndex
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    /**
     This method handles the event caused by the skip button press action. This performs a segue to the main
     page.
     
     - Author: Aarón Granado Amores.
     */
    @objc private func handleSkip() {
        showInfoAlert(message: cons.updateAlertMessage)
    }
    
    //MARK: AlertDialog
    
    /**
     This method shows an Alert with the given message.
     
     - Parameter message: The message to be displayed.
     - Author: Aarón Granado Amores.
     */
    func showInfoAlert(message: String) {
        let alertController = UIAlertController(title: "INFO", message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Cancelar", style: .destructive, handler: { (UIAlertAction) in self.performSegue() }))
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in self.fetchFromFirebase() }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: Fetch exercises from Firebase
    
    /**
     This method searches on Firebase for all the data and the saves or updates the values stored on CoreData.
     
     - Author: Aarón Granado Amores.
     */
    func fetchFromFirebase() {
        let updateDialog = UIAlertController(title: "ACTUALIZANDO", message: self.cons.firebaseUpdatingMessage, preferredStyle: .alert)
        
        self.present(updateDialog, animated: true, completion: nil)
        self.fetchExercises()
        updateDialog.dismiss(animated: true, completion: nil)
    }
    
    func fetchExercises() {
        database.collection("exercises").getDocuments { (snapshot, error) in
            if error != nil {
                self.fetchRoutines()
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
                
                self.fetchRoutines()
            }
        }
    }
    
    func fetchRoutines() {
        database.collection("routines").getDocuments { (snapshot, error) in
            if error != nil {
                self.performSegue()
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
                
                self.performSegue()
            }
        }
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
    
    //MARK: Segue to Main Layout
    
    /**
     This method performs a segue to the main page and saves into UserDefaults a boolean value for skipping the
     intro page controller if it has already been displayed to the user.
     
     ## Important Notes ##
     1. Look at **AppDelegate** to see how this variable is used
     
     - Author: Aarón Granado Amores.
     */
    func performSegue(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainPage = storyboard.instantiateViewController(withIdentifier: "mainPage")
        let preferences = UserDefaults.standard
        let currentKey = "hasIntroBeenShown"
        
        preferences.set(true, forKey: currentKey)
        
        let didSave = preferences.synchronize()
        
        if didSave {
            self.present(mainPage, animated: true, completion: nil)
        } else {
            print("Error saving to preferences")
        }
    }
}

extension PageController: UICollectionViewDelegateFlowLayout {
    //MARK: Delegates
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath) as! PageCell
        let page = pages[indexPath.item]
        
        cell.page = page
        
        return cell
    }
    
    /// This method override makes the pages snap to the edges when the scroll ends.
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.x
        
        pageControl.currentPage = Int(x / view.frame.width)
    }
    
    /// This method override makes the layout work correctly both on portrait and landscape modes.
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (_) in
            self.collectionViewLayout.invalidateLayout()
            
            if self.pageControl.currentPage == 0 {
                self.collectionView?.contentOffset = .zero
            } else {
                let indexPath = IndexPath(item: self.pageControl.currentPage, section: 0)
                
                self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
        }, completion: nil)
    }
}
