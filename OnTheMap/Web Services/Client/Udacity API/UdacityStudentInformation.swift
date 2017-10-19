//
//  UdacityStudentInformation.swift
//  OnTheMap
//
//  Created by Luciano Schillagi on 9/14/17.
//  Copyright © 2017 Luko. All rights reserved.
//

/* Networking */

import Foundation

/*
Abstract:
Contiene métodos para obtener información del usuario (su nombre completo).
*/

extension Udacity {
	
	// MARK: Udacity User Info
	
	/**
	Con los datos obtenidos mediante los métodos 'getFirstName' y 'getLastName' crea la solicitud 'GETing Public User Data' para obtener datos acerca del usuario.
	
	- parameter completionHandlerForStudentName: los resultados obtenidos a través de la solicitud (un array de diccionarios)
	
	*/
	
	func getStudentName(_ completionHandlerForStudentName: @escaping (_ success: Bool, _ error: String?) -> Void) {
	
		// Step-1: Set the parameters
		let id: String
		
		if let stringUserID = userID {
			id = "/" + stringUserID
		} else {
			id = "/"
		}
		
		// Step-2: Build the URL
		let request = NSMutableURLRequest(url: url(Constants.Methods.ApiPathUsers + id))
		
		// Step-3: Make the request
		let _ = taskForGETMethod(request) { (success, error, result) in
			
			// GUARD: if there was an error
			guard (error == nil) else {
				completionHandlerForStudentName(false, error)
				return
			}
		
				// Get student name
				if success {
				
					// Success: save parsed JSON data
					self.jsonData = result
					
					self.getFirstName(self.jsonData) { (success, error, result) in
						if success {
						
							// Success: save studen first name
							self.firstName = result
						
							self.getLastName(self.jsonData) { (succes, error, result) in
							
								if success {
									self.lastName = result
									
									completionHandlerForStudentName(true, nil)
							
	
								} else {
									completionHandlerForStudentName(false, error)
								}
							}
						} else {
							completionHandlerForStudentName(false, error)
						}
					}
				} else {
					completionHandlerForStudentName(false, error)
				}
		}
}

	/**
	Obtiene el nombre el usuario.
	
	- parameter jsonData: el objeto json obtenido con la respuesta exitosa de la solicitud.
	- parameter completionHandlerForFirstName: comprueba si el valor 'first_name' ha sido obtenido o no. Si ha sido obtenido lo almacena temporalmente en un enlace opcional.

	*/
	
	func getFirstName(_ jsonData: AnyObject, completionHandlerForFirstName: (_ success: Bool, _ error: String?, _ result: String?) -> Void) {
	
		// GUARD: if user info key is not in the result
		guard let userInfo = jsonData[Constants.JSONResponseKeys.UserInfo] as? [String: AnyObject] else {
			completionHandlerForFirstName(false, Errors.Message.userInfo.description, nil)
			return
		}
	
		// Get user info - First Name
		if let stringFirstName = userInfo[Constants.JSONResponseKeys.FirstName] as? String {
			completionHandlerForFirstName(true, nil, stringFirstName)
		} else {
			completionHandlerForFirstName(true, nil, "")
		}
	}
	
	/**
	Obtiene el apellido el usuario.
	
	- parameter jsonData: el objeto json obtenido con la respuesta exitosa de la solicitud.
	- parameter completionHandlerForFirstName: comprueba si el valor 'last_name' ha sido obtenido o no. Si ha sido obtenido lo almacena temporalmente en un enlace opcional.
	
	*/
	
	func getLastName(_ jsonData: AnyObject, completionHandlerForLastName: (_ success: Bool, _ error: String?, _ result: String?) -> Void) {
		
		// GUARD: if user info key is not in the result
		guard let userInfo = jsonData[Constants.JSONResponseKeys.UserInfo] as? [String: AnyObject] else {
			completionHandlerForLastName(false, Errors.Message.userInfo.description, nil)
			return
		}
		
		// Get user info - Last Name
		if let stringLastName = userInfo[Constants.JSONResponseKeys.LastName] as? String {
			completionHandlerForLastName(true, nil, stringLastName)
		} else {
			completionHandlerForLastName(true, nil, "")
		}
	}

}
