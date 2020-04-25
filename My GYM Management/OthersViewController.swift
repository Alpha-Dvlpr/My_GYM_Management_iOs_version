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
    @IBAction func privacyButtonPressed(_ sender: UIBarButtonItem) {
        guard let privacyURL = URL(string: cons.privacyURL) else { return }
    
        UIApplication.shared.open(privacyURL)
    }
    
    @IBAction func contactButtonPressed(_ sender: UIBarButtonItem) {
        showMailcomposer()
    }
    
    @IBAction func imcCalcButtonPressed(_ sender: UIButton) {
        print("Calculating IMC...")
    }
    
    @IBAction func locateGymButtonPressed(_ sender: UIButton) {
        openAppleMaps()
    }
    
    @IBAction func updateDataButtonPressed(_ sender: UIButton) {
    
    }
    
    //MARK: Open Maps
    func openAppleMaps() {
        if (UIApplication.shared.canOpenURL(URL(string:"http://maps.apple.com")!)) {
            UIApplication.shared.open(URL(string: cons.appleMapsURL)!)
        } else {
            NSLog("Can't use Apple Maps");
        }
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
}

extension OthersViewController: MFMailComposeViewControllerDelegate{
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
