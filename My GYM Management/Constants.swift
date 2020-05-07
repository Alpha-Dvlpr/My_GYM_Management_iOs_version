//
//  Constants.swift
//  My GYM Management
//
//  Created by Aaron Granado Amores on 7/4/20.
//  Copyright © 2020 AlphaDvlpr. All rights reserved.
//

import Foundation

class Constants {
    /// The email adressess to be used when sendin a contact email.
    var emailAddresses: [String] = ["aarongranado98@gmail.com", "albertomccaceres@gmail.com"]
    
    /// The subject to be placed on the email.
    var emailSubject: String = "Email de contacto"
    
    /// The message placeholder for the email.
    var emailBody: String = "Contacta con nosotros y responderemos en la mayor brevedad posible.\n--------------\n"
    
    /// The URL where the Privacy Policy is hosted.
    var privacyURL: String = "http://alpha-dvlpr.mozello.com/privacy-policy/"
    
    /// The URL for searching near gyms.
    var appleMapsURL: String = "https://maps.apple.com/?q=gimnasio"
    
    /// The predefined color for the routines if there's no color selected.
    var predefinedRoutineColor: String = "#3DFFEC"
    
    /// The first color for the radiobuttons.
    var routineColorOne: String = "#FF0000"
    
    /// The second color or the radiobuttons.
    var routineColorTwo: String = "#00FF00"
    
    /// The third color for the radiobuttons.
    var routineColorThree: String = "#0000FF"
}
