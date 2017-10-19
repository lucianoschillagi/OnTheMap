//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Luciano Schillagi on 8/18/17.
//  Copyright © 2017 Luko. All rights reserved.
//

/* Networking */

import Foundation

/*
Abstract:
Contiene los métodos tanto para obtener el objeto parse 'StudentLocation' (con la información de múltiples estudiantes) como para crear un nuevo objeto (single) dentro del objeto 'StudentLocation'.
*/

// MARK: - Parse API Client

class Parse : NSObject {
	
	// MARK: Properties
	let session = URLSession.shared
	
  // MARK: Initializers
  override init() {
    super.init()
  }
	
	// MARK: Get student locations (multiple) - GET
	
	/**
	Obtiene el objeto 'StudentLocation'.
	
	- parameter completionHandlerForStudentsInformation: comprueba si la solicitud ha sido exitosa o no. En caso de serlo, almacena los datos obtenidos temporalmente.
	
	*/
	
	func getStudentsInformation(_ completionHandlerForStudentsInformation: @escaping (_ success: Bool, _ error: String?, _ result:[StudentInformation]?) -> Void) {
		
		// Step-1: set the parameters
		let parameters: [String:AnyObject] = [
			Constants.MethodParameterKeys.Limit: Constants.MethodParameterValues.Limit as AnyObject,
		//Constants.MethodParameterKeys.Skip: Constants.MethodParameterValues.Skip as AnyObject,
			Constants.MethodParameterKeys.Order: Constants.MethodParameterValues.Order as AnyObject
		]
		
		// Step-2: build the URL
		let request = NSMutableURLRequest(url: url(Constants.Methods.ApiPath, parameters))
		
		// Step-3: make the request
		let _ = taskForGETMethod(request) { (success, error, result) in
			
			
		// GUARD: if there was an error
		guard (error == nil) else {
			completionHandlerForStudentsInformation(false, error, nil)
			return
			}
			
			// Get student information
			if success {
				if let result = result?[Constants.JSONKeys.Results] as? [[String:AnyObject]] {
					let studentInformation = StudentInformation.allProfilesFrom(result)
					completionHandlerForStudentsInformation(true, nil, studentInformation)
				} else {
					completionHandlerForStudentsInformation(false, Errors.Message.getStudentsInformationError.description, nil)
				}
			}
		}
	}
	
	// MARK: Create new student location - POST
	
	/**
	Crea un nuevo objeto con los datos actualizados de un estudiante.
	
	- parameter parameters: pasa los datos nuevos ingresados por el usuario en el 'StudentInformationVC' al cuerpo de esta soliciud. (!)
	
	- parameter completionForNewStudentLocation: comprueba si la solicitud ha sido exitosa o no.

	*/
	
	func createNewStudentLocation(_ parameters: [String:AnyObject], _ completionForNewStudentLocation: @escaping (_ success: Bool, _ error: String?) -> Void) {
		
		// Step-2: build the URL
		let request = NSMutableURLRequest(url: url())
		
			// Step-3: configure the request
			request.httpMethod = Constants.MethodType.Post
			request.addValue(Constants.HeadersValues.ParseApplicationID, forHTTPHeaderField: Constants.HeadersKeys.ParseApplicationID)
			request.addValue(Constants.HeadersValues.ParseRestAPIKey, forHTTPHeaderField: Constants.HeadersKeys.ParseRestAPIKey)
			request.addValue(Constants.HeadersValues.ApplicationJson, forHTTPHeaderField: Constants.HeadersKeys.ContentType)
			request.httpBody = jsonRequestBody(parameters) // notar como le paso los parámetros desde el CUERPO de la solicitud
		
		// Configure the request...
		let _ = taskForPOSTMethod(request) { (success, error) in
			
			// GUARD: if there was an error
			guard (error == nil) else {
				completionForNewStudentLocation(false, error)
				return
			}
			// if new location is added
			if success {
				completionForNewStudentLocation(true, nil)
			} else {
				completionForNewStudentLocation(false, Errors.Message.createNewStudentLocationError.description)

			}
		}
	}
	
	class func sharedInstance() -> Parse {
		struct Singleton {
			static var sharedInstance = Parse()
		}
		return Singleton.sharedInstance
	}
}

