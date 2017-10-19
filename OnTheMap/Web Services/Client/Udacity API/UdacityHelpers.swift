//
//  UdacityHelpers.swift
//  OnTheMap
//
//  Created by Luciano Schillagi on 9/14/17.
//  Copyright © 2017 Luko. All rights reserved.
//

/* Networking */

import Foundation

/*
Abstract:
Contiene métodos auxiliares para configurar las diversas solicitudes web a la API de Udacity.
*/

// MARK: Udacity API (Helpers)

extension Udacity {
	
	// MARK: Request
	
	/**
	Realiza tareas comunes a todos los métodos GET de las solicitudes a la API de Udacity.
	
	- parameter request: toma una solicitud GET determinada.
	- parameter completionHandlerForGET: comprueba si la solicitud ha sido exitosa o no. Si ha sido exitosa almacena el resultado (para luego parsearlo).
	
	*/
	
	func taskForGETMethod(_ request:NSMutableURLRequest, completionHandlerForGET: @escaping (_ success: Bool, _ error: String?, _ result:AnyObject?) -> Void) -> URLSessionDataTask {
	
		// Step-3, 4: Configure the request
		let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
			
			// GUARD-a: if there was an error
			guard (error == nil) else {
				completionHandlerForGET(false, error?.localizedDescription, nil)
				return
			}
			
			// GUARD-b: if response is not in success range
			guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
				completionHandlerForGET(false, Errors.Message.sessionRequestError.description, nil)
				return
			}
			
			// GUARD-c: if response is in server error range (500-599)
			guard let serverError = (response as? HTTPURLResponse)?.statusCode, serverError >= 200 && serverError <= 499 else {
				completionHandlerForGET(false, error?.localizedDescription, nil)
				return
			}
			
			// GUARD-d: if not data was returned
			guard let data = data else {
				completionHandlerForGET(false, Errors.Message.sessionRequestDataError.description, nil)
				return
			}
			
			// Step-5, 6: Parse and use the data
			self.parseData(data, completionHandlerForParsedData: completionHandlerForGET)
		}
			// Step-7: Start the request
			task.resume()
		
		return task
	}
	
	/**
	Configura la URL a enviar en las solicitudes web a la API de Udacity.
	
	- parameter path: toma el 'path' de la solicitud.
	- parameter withPathExtension: toma el 'pathExtension' (si es que lo tiene) de la solicitud.
	
	- returns: devuelve la URL ya configurada.
	
	*/
	
	func url(_ path: String, _ withPathExtension: String? = nil) -> URL {
		
		var components = URLComponents()
		components.scheme = Constants.ApiScheme
		components.host = Constants.ApiHost
		components.path = path + (withPathExtension ?? "") // + path extension <user_id>
		
		return components.url!
	}

	/**
	Configura el objeto json que irá en la solicitud web 'POSTing a Session'
	
	- parameter parameters: toma un diccionario de tipo '[String:AnyObject]' con los datos ingresados por el usuario (su email y contraseña).
	
	- returns: devuelve el objeto json ya configurado listo para enviar.
	
	*/
	
	func jsonBody(_ parameters:[String:AnyObject]) -> Data {
		
		// Build JSON body from parameters
		// Authentication: Udacity username(email) & password
		let jsonBody: Data = "{\"\(Constants.JSONBodyKeys.Udacity)\":{\"\(Constants.JSONBodyKeys.Username)\":\"\(parameters[Constants.JSONBodyKeys.Username]!)\",\"\(Constants.JSONBodyKeys.Password)\":\"\(parameters[Constants.JSONBodyKeys.Password]!)\"}}".data(using: String.Encoding.utf8)!
		
		return jsonBody
	}
	
	// MARK: Response

	/**
	Toma los objetos json de las respuestas a la solicitudes y los convierte en un objeto 'Foundation' usable.
	
	- parameter data: toma los datos crudos (json objects).

	- parameter completionHandlerForParsedData: comprueba si los datos han sido parseados exitosamente o no. En caso de haber sido parseados almacena temporamente el resultado.
	
	*/
	
	func parseData(_ data: Data, completionHandlerForParsedData: (_ success: Bool, _ error: String?, _ result: AnyObject?) -> Void) {
		
		// Parse the data
		let range = Range(uncheckedBounds: (5, data.count))
		let newData = data.subdata(in: range) /* subset response data! */
		
		var parsedResult: AnyObject! = nil
		do {
			parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as AnyObject
		} catch {
		completionHandlerForParsedData(false, Errors.Message.parseDataError.description, nil)
		return
		}
		// User parsed data
		completionHandlerForParsedData(true, nil, parsedResult)
	}
}






