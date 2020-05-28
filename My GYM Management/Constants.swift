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
    var emailAddresses: [String] = ["aarongranado98@gmail.com", "albertomccaceres@gmail.com"]
    var emailSubject: String = "Email de contacto"
    var emailBody: String = "Contacta con nosotros y responderemos en la mayor brevedad posible.\n--------------\n"
    var privacyURL: String = "http://alpha-dvlpr.mozello.com/privacy-policy/"
    var appleMapsURL: String = "https://maps.apple.com/?q=gimnasio"
    
    // The colors for the routine color radioButtons and its names.
    var predefinedRoutineColor: String = "#8052FF"
    var routineColorOne: String = "#FF0000"
    var routineColorTwo: String = "#4F8F00"
    var routineColorThree: String = "#0000FF"
    var colorNames: [String] = ["Rojo", "Verde", "Azul"]
    
    // The colors for the routine difficulty radioButtons.
    var difficultyColorOne: String = "#FF0000"
    var difficultyColorTwo: String = "#FF9300"
    var difficultyColorThree: String = "#4F8F00"
    
    // The titles and descriptions for the introduction pages.
    var titles: [String] = ["My GYM Management",
                            "Guarda tus propias rutinas y ejercicios",
                            "Rutinas predefinidas en la nube",
                            "Calcula tu IMC",
                            "Localiza gimnasios",
                            "Comparte con tus amigos",
                            "Danos 5 estrellas en el App Store"]
    var descriptions: [String] = ["Gestiona tus entrenamientos y rutinas en casa y en el gimnasio de manera fácil y rápida y desde cualquier lugar.\n¡Incluso sin conexión a internet!",
                                  "Crea tus propias rutinas y ejercicios de manera fácil.\nTambién tendrás la opción de editarlas en cualquier momento.",
                                  "Actualiza los datos de la app desde la sección 'Otros' para recibir una gran selección de rutinas y ejercicios actualizados y en constante crecimiento.",
                                  "Calcula tu Índice de Masa Corporal y observa de manera gráfica tu progreso y tus objetivos de peso.",
                                  "Localiza los gimnasios y centros deportivos cercanos a tu ubicación con un solo click.\n\n(Requiere 'Apple Maps')",
                                  "Comparte las rutinas y ejercicios a través de tus redes sociales preferidas.",
                                  "Si te ha gustado la app no te olvides de dejarnos 5 estrellas en el App Store y de compartir la aplicación con tus amigos.\nValoramos todos los comentarios."]
    
    // Other messages or values.
    var firebaseErrorMessage: String = "Ha ocurrido un error obteniendo los nuevos datos, prueba a revisar tu conexión a internet e inténtalo de nuevo."
    var updateAlertMessage: String = "¿Desea descargar ahora todos los ejercicios y rutinas predefinidos?\nPuede realizar esta acción en cualquier momento desde la ventana 'Otros'."
    var firebaseUpdatingMessage: String = "Actualizando datos, por favor espere."
    
    // Alert Dialogs and new Exercises/Routines texts.
    var allFieldsAreCompulsory: String = "Debes completar todos los campos obligatorios."
    var linkError: String = "No se puede abrir el enlace.\nPuede que esté mal introducido."
    var cannotDeletedPredefinedExercise: String = "No puedes eliminar un ejercicio predefinido"
    var userMustAddOrUpdate: String = "Debes añadir algún ejercicio o actualizar la aplicación desde la pestaña 'Otros' para obtener todos los ejercicios y rutinas predefinidos desde la nube."
    var userMustSelectOneDay: String = "Debes seleccionar al menos un día"
    var userMustTypeAName: String = "Debes introducir un nombre"
    var noObjective: String = "No hay ningún objetivo definido para esta rutina"
    var noMuscles: String = "No hay músculos implicados en esta rutina"
    var noInfo: String = "No hay información"
}
