//
//  PageCell.swift
//  My GYM Management
//
//  Created by Aaron Granado Amores on 8/5/20.
//  Copyright © 2020 AlphaDvlpr. All rights reserved.
//

import UIKit

class PageCell: UICollectionViewCell {
    
    //MARK: Variables and constants
    private var centralStack: UIStackView!
    
    /**
     This variable checks if the page has been set correctly and sets all the received informtion on the
     correct view.
     
     - Author: Aarón Granado Amores.
     */
    var page: Page? {
        didSet {
            guard let unwrappedPage = page else { return }
            
            titleLabel.text = unwrappedPage.titleText
            descriptionLabel.text = unwrappedPage.descriptionText
        }
    }
    
    //MARK: Main functions
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(red: 179/255, green: 248/255, blue: 255/255, alpha: 1)
        addViewToLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Layout setup
    
    /**
     This method adds the custom views to the layout and sets some attributes for the stack view.
     
     - Author: Aarón Granado Amores.
     */
    func addViewToLayout() {
        centralStack = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        
        centralStack.translatesAutoresizingMaskIntoConstraints = false
        centralStack.distribution = .fill
        centralStack.axis = .vertical
        centralStack.spacing = 16
        
        addSubview(centralStack)
        
        setupConstraints()
    }
    
    /**
     This method sets the constrints for all the views on the layout
     
     - Author: Aarón Granado Amores.
     */
    func setupConstraints() {
        centralStack.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        centralStack.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor).isActive = true
        centralStack.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 32).isActive = true
        centralStack.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -32).isActive = true
    }
    
    //MARK: UI Elemnts
    
    /**
     Custom label for showin the title of the page.
     
     - Author: Aarón Granado Amores.
     */
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        
        return label
    }()
    
    /**
     Custom label for showing a brief description of the page.
     
     - Author: Aarón Granado Amores.
     */
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .center
        label.numberOfLines = 7
        
        return label
    }()
}
