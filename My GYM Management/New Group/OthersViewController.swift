//
//  OthersViewController.swift
//  My GYM Management
//
//  Created by Aaron Granado Amores on 6/4/20.
//  Copyright © 2020 AlphaDvlpr. All rights reserved.
//

import UIKit
import MessageUI

class OthersViewController: UIViewController {

    //MARK: UI elements connection
    @IBOutlet weak var locateGymButonOutlet: UIButton!
    
    //MARK: Variables and constants
    var cons = Constants()
    
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
     This method sets the action for the imc calculator button.
     
     - Parameter sender: The sender of the action (In this case uIButton).
     - Author: Aarón Granado Amores.
     */
    @IBAction func imcCalcButtonPressed(_ sender: UIButton) {
        print("Calculating IMC...")
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
        print("Updating data....")
    }
    
    //MARK: Open Maps
    
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
