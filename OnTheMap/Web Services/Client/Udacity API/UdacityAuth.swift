//
//  UdacityAuth.swift
//  OnTheMap
//
//  Created by Luciano Schillagi on 9/14/17.
//  Copyright © 2017 Luko. All rights reserved.
//

/* Networking */

import Foundation

/*
Abstract:
Contiene métodos para autenticar al usuario mediante la API de Udacity (crear una sesión de usuario) obteniendo valores como 'sessionID' y 'userID' y un método para borrar la sesión.

/*
Steps for Authentication via Udacity API

Step 1: Ask the user for permission via the API ("login")
Step 2: Get a session ID
Step 3: Create a session

Extra Steps...
Step 3: Get the user id ;)
Step 4: Go to the next view!
*/

*/

extension Udacity {
	
// MARK: Udacity Authentication
	
	/**
	Loguea al usuario con su 'session ID'.
	Obtiene y almacena el 'session ID' y el 'userID' provisto por la API de Udacity.
	
	- parameter parameters: los parámetros que irán en el cuerpo de la solicitud 'POSTing a Session'.
	- parameter completionHandlerForLogin: comprueba si el encadenamiento de solicitudes ha sido exitoso o no.
	*/
	
	func loginWithID(_ parameters: [String:String], completionHandlerForLogin: @escaping (_ success: Bool, _ error: String?) -> Void) {
		
	// Chain completion handlers for each request so that they run one after the other
		createSession(parameters) { (success, error, result) in

			if success {
			// Success: save parsed JSON data
				self.jsonData = result
				
					self.getSessionID(self.jsonData) { (success, error, result) in
						
						if success {
						// Success: save session ID
						self.sessionID = result
					
							self.getUserID(self.jsonData) { (success, error, result) in
								
								if success {
									// Success: save user ID
									self.userID = result
							
										completionHandlerForLogin(true, nil) // caso de éxito, aprobó la serie de pasos anteriores

								} else {
									completionHandlerForLogin(false, error)
								}
							}
						} else {
							completionHandlerForLogin(false, error)
					}
				}
			} else {
				completionHandlerForLogin(false, error)
		}
	}
}
	
	// Udacity API: POSTing a Session
	
	/**
	Crea la solicitud web 'POSTing a Session'.
	
	- Parameter parameters: Los parámetros que irán en el cuerpo de la solicitud (email y contraseña del usuario).
	- Parameter completionHandlerForSession: comprueba si la solicitud ha sido exitosa o no.
	
	*/
	
	func createSession(_ parameters: [String:String], completionHandlerForSession: @escaping (_ success: Bool, _ error: String?, _ result: AnyObject?) -> Void) {
		
		// Step-2: Build the URL
		let request = NSMutableURLRequest(url: url(Constants.Methods.ApiPathSession))
		
		// Step-3: Configure the request
		request.httpMethod = Constants.MethodType.Post
		request.addValue(Constants.HeadersValues.ApplicationJson, forHTTPHeaderField: Constants.HeadersKeys.Accept)
		request.addValue(Constants.HeadersValues.ApplicationJson, forHTTPHeaderField: Constants.HeadersKeys.ContentType)
		request.httpBody = jsonBody(parameters as [String : AnyObject])
		
		// Step-4: Make the request
		let task = session.dataTask(with: request as URLRequest) { data, response, error in
			
			// GUARD-a: if there was an error
			guard (error == nil) else {
				completionHandlerForSession(false, error?.localizedDescription, nil)
				return
			}
			
			// GUARD-b: if response is not success range
			guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
					completionHandlerForSession(false, Errors.Message.incorrectCredentials.description, nil)
				return
				}
			
			// GUARD-c: if response is in server error range (500-599)
			guard let serverError = (response as? HTTPURLResponse)?.statusCode, serverError >= 200 && serverError <= 499 else {
				completionHandlerForSession(false, error?.localizedDescription, nil)
				return
			}
			
			// GUARD-d: if no data was returned
			guard let data = data else {
				completionHandlerForSession(false, Errors.Message.sessionRequestDataError.description, nil)
				return
			}
			
		// Step-5, 6: Parse and use the data
			self.parseData(data, completionHandlerForParsedData: completionHandlerForSession)
			
		}
		// Step-7: Start the request
		task.resume()
	}

	/**
	Obtiene el identificador de sesión del usuario (requisito para loguearse)
	
	- Parameter jsonData: el objeto json obtenido con la respuesta exitosa de la solicitud.
	- Parameter completionHandlerForSessionID: comprueba si este valor (el 'sessionID') ha sido obtenido o no. Si ha sido obtenido lo almacena temporalmente en un enlace opcional.
	
	*/
	
	func getSessionID(_ jsonData:AnyObject, completionHandlerForSessionID: (_ success: Bool, _ error: String?, _ result: String?) -> Void) {
		
		// GUARD if 'session' key is not in the result
		guard let session = jsonData[Constants.JSONResponseKeys.Session] as? [String:AnyObject] else {
			completionHandlerForSessionID(false, Errors.Message.sessionID.description, nil)
			return
		}
		
		// Get Session ID
		if let sessionID = session[Constants.JSONResponseKeys.SessionID] as? String {
			completionHandlerForSessionID(true, nil, sessionID)
		} else {
			completionHandlerForSessionID(false, Errors.Message.sessionID.description, nil)
		}
	}
	
	/**
	Obtiene el identificador del usuario (dato que se utilizará en una posterior solicitud).
	
	- Parameter jsonData: el objeto json obtenido con la respuesta exitosa de la solicitud.
	- Parameter completionHandlerForUserID: comprueba si este valor (el 'sessionID') ha sido obtenido o no. Si ha sido obtenido lo almacena temporalmente en un enlace opcional.
	
	*/
	
	func getUserID(_ jsonData: AnyObject, completionHandlerForUserID: (_ success: Bool,_ error: String?,_ result: String?) -> Void) {
	
		// GUARD if 'account' key is not in the result
		guard let account = jsonData[Constants.JSONResponseKeys.Account] as? [String: AnyObject]
			else {
				completionHandlerForUserID(false, Errors.Message.userID.description, nil)
				return
		}
		
		// Get user ID (account->key)
		if let userID = account[Constants.JSONResponseKeys.UserID] as? String {
			completionHandlerForUserID(true, nil, userID)
		} else {
			completionHandlerForUserID(false, Errors.Message.userID.description, nil)
		}	
	}
	
	/**
	Borra la sesión actual del usuario.
	
	- Parameter completionHandlerForDeleteSession: comprueba si la solicitud ha sido exitosa o no.
	
	*/
	// Udacity API: DELETEing a Session
	func deleteSession(completionHandlerForDeleteSession: @escaping (_ success: Bool, _ error: String?) -> Void) {
		
		// Step-1: Build the URL
		let request = NSMutableURLRequest(url: url(Constants.Methods.ApiPathSession))
		
		// Step-2: Configure the request
		request.httpMethod = Constants.MethodType.Delete
		
		var xsrfCookie: HTTPCookie? = nil
		let sharedCookieStorage = HTTPCookieStorage.shared
		
		for cookie in sharedCookieStorage.cookies! {
			if cookie.name == Constants.HeadersValues.CookieNameXSRF {
				xsrfCookie = cookie
			}
		}
		
		if let xsrfCookie = xsrfCookie {
			request.setValue(xsrfCookie.value, forHTTPHeaderField: Constants.HeadersKeys.XXsrfToken)
		}
		
		// Step-3: Make the request
		let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
			
		// Step-4: Send status to completion handler
			if error != nil {
				completionHandlerForDeleteSession(false, error?.localizedDescription)
				return
			} else {
				completionHandlerForDeleteSession(true, nil)
			}
		}
		// Step-5: Start the request
		task.resume()
	}

	// MARK: Shared Instance
	
	class func sharedInstance() -> Udacity {
		struct Singleton {
			static var sharedInstance = Udacity()
		}
		return Singleton.sharedInstance
	}
	
}



