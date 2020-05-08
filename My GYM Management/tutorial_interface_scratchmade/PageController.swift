//
//  PageController.swift
//  My GYM Management
//
//  Created by Aaron Granado Amores on 8/5/20.
//  Copyright © 2020 AlphaDvlpr. All rights reserved.
//

import UIKit

class PageController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    //MARK: Variables and constants
    private var bottomStack: UIStackView!
    
    /**
     This array holds all the pages that will be displayed on the introductory page controller
     
     - Author: Aarón Granado Amores.
     */
    let pages = [
        Page(titleText: "My GYM Management",
             descriptionText: "Gestiona tus entrenamientos y rutinas en casa y en el gimnasio de manera fácil y rápida."),
        Page(titleText: "Guarda cosas",
             descriptionText: "Crea tus propias rutinas y ejercicios."),
        Page(titleText: "Actualiza datos",
             descriptionText: "Actualiza los datos para recibir las últimas rutinas actualizadas."),
        Page(titleText: "Comparte",
             descriptionText: "Comparte las rutinas y ejercicios a través de tus redes sociales."),
        Page(titleText: "Dale like",
             descriptionText: "Danos 5 estrellas en el AppStore")
    ]
    
    //MARK: Main function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addViewsToLayout()
        
        collectionView.backgroundColor = UIColor(red: 179/255, green: 248/255, blue: 255/255, alpha: 1)
        collectionView.register(PageCell.self, forCellWithReuseIdentifier: "cellID")
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
    }
    
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
            performSegue()
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
        performSegue()
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
        }
    }
}
