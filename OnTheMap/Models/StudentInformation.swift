//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Luciano Schillagi on 7/8/17.
//  Copyright © 2017 Luko. All rights reserved.
//

/* Model */

import Foundation

/*
Abstract:
Una estructura preparada para recibir, mapear y almacenar el objeto 'Student Location' obtenido de la API de Parse.
*/

// MARK: - Parse API Client

// MARK: Student Information
struct StudentInformation {
	
  // MARK: Properties
	let objectID: String
  let uniqueKey: String
  let firstName: String
  let lastName: String
  let mapString: String
  let latitude: Double
  let longitude: Double
	let mediaURL: String
	
  // MARK: Initializer
	init(dictionary: [String:AnyObject]) { // esta estructura acepta una diccionario [String:AnyObject] como argumento
		if let stringObjectID = dictionary[Parse.Constants.JSONKeys.ObjectId] as? String {
			objectID = stringObjectID
		} else {
			objectID = ""
		}
		
		if let stringUniqueKey = dictionary[Parse.Constants.JSONKeys.UniqueKey] as? String {
			uniqueKey = stringUniqueKey
		} else {
			uniqueKey = ""
		}
		
		if let stringFirstName = dictionary[Parse.Constants.JSONKeys.FirstName] as? String {
			firstName = stringFirstName
		} else {
			firstName = ""
		}
		
		if let stringLastName = dictionary[Parse.Constants.JSONKeys.LastName] as? String {
			lastName = stringLastName
		} else {
			lastName = ""
		}
		
		if let stringMapString = dictionary[Parse.Constants.JSONKeys.MapString] as? String {
			mapString = stringMapString
		} else {
			mapString = ""
		}
		
		if let doubleLatitude = dictionary[Parse.Constants.JSONKeys.Latitude] as? Double {
			latitude = doubleLatitude
		} else {
			latitude = 0.0
		}
		
		if let doubleLongitude = dictionary[Parse.Constants.JSONKeys.Longitude] as? Double {
			longitude = doubleLongitude
		} else {
			longitude = 0.0
		}
		
		if let stringMediaURL = dictionary[Parse.Constants.JSONKeys.MediaURL] as? String {
			mediaURL = stringMediaURL
		} else {
			mediaURL = ""
		}
	}

/**
Toma el array de diccionarios obtenidos en el objeto 'Student Location' y devuelve una estructura que contiene un array de diccionarios (StudentInformation). Convierte el objeto 'Parse' a un objeto 'Foundation'.

- parameter results: los resultados obtenidos a través de la solicitud (un array de diccionarios)

- returns: un array de objetos usables (Foundation) 'StudentInformation'
*/
  static func allProfilesFrom(_ results: [[String:AnyObject]]) -> [StudentInformation] {
    
    var studentInformation = [StudentInformation]()
    
		// iterar a través de los resultados del array  donde cada 'StudentInformation' es un diccionario
		// de esta forma obtenemos un colección de objetos ´StudentInformation´ (no uno solo) al agregar cada objeto a la estructura ´StudentInformation´
    for result in results {
      studentInformation.append(StudentInformation(dictionary: result))
    }
    
    return studentInformation
  }
	
	// student location -> student information stored
	static var studentInformationStored = [StudentInformation]()

}



