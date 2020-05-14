//
//  Constants.swift
//  My GYM Management
//
//  Created by Aaron Granado Amores on 7/4/20.
//  Copyright © 2020 AlphaDvlpr. All rights reserved.
//

import Foundation

/**
 This class contins several variables that are used all over the application.
 Those variables can be changed several times along the development of the app.
 
 - Author: Aarón Granado Amores.
 */
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
    
    /// The first color for the radiobuttons. (Red)
    var routineColorOne: String = "#FF0000"
    
    /// The second color or the radiobuttons. (Green)
    var routineColorTwo: String = "#4F8F00"
    
    /// The third color for the radiobuttons. (Blue)
    var routineColorThree: String = "#0000FF"
    
    /// The titles for the introduction pages.
    var titles: [String] = ["My GYM Management",
                            "Guarda tus propias rutinas y ejercicios",
                            "Rutinas predefinidas en la nube",
                            "Calcula tu IMC",
                            "Localiza gimnasios",
                            "Comparte con tus amigos",
                            "Danos 5 estrellas en el App Store"]
    
    /// The descriptions for the introduction pages.
    var descriptions: [String] = ["Gestiona tus entrenamientos y rutinas en casa y en el gimnasio de manera fácil y rápida y desde cualquier lugar.\n¡Incluso sin conexión a internet!",
                                  "Crea tus propias rutinas y ejercicios de manera fácil.\nTambién tendrás la opción de editarlas en cualquier momento.",
                                  "Actualiza los datos de la app desde la sección 'Otros' para recibir una gran selección de rutinas y ejercicios actualizados y en constante crecimiento.",
                                  "Calcula tu Índice de Masa Corporal y observa de manera gráfica tu progreso y tus objetivos de peso.",
                                  "Localiza los gimnasios y centros deportivos cercanos a tu ubicación con un solo click.\n\n(Requiere 'Apple Maps')",
                                  "Comparte las rutinas y ejercicios a través de tus redes sociales preferidas.",
                                  "Si te ha gustado la app no te olvides de dejarnos 5 estrellas en el App Store y de compartir la aplicación con tus amigos.\nValoramos todos los comentarios."]
}
