//
//  ParseHelpers.swift
//  OnTheMap
//
//  Created by Luciano Schillagi on 8/18/17.
//  Copyright © 2017 Luko. All rights reserved.
//

/* Networking */

import Foundation

/*
Abstract:
Contiene métodos auxiliares para configurar las diversas solicitudes web a la API de Parse.
*/

// MARK: Parse API (Helpers)

extension Parse {

	// MARK: Request
	
	/**
	Realiza tareas comunes a todos los métodos GET de las solicitudes web a la API de Parse.
	
	- parameter request: toma una solicitud GET determinada.
	
	- parameter completionHandlerForGET: comprueba si la solicitud ha sido exitosa o no. En caso de serlo almacena temporalmente el resultado.
	
	*/
	
	func taskForGETMethod(_ request:NSMutableURLRequest, completionHandlerForGET: @escaping (_ success: Bool, _ error: String?, _ result:AnyObject?) -> Void) -> URLSessionDataTask {
		
		// Step-3: Configure the request
		request.addValue(Constants.HeadersValues.ParseApplicationID, forHTTPHeaderField: Constants.HeadersKeys.ParseApplicationID)
		request.addValue(Constants.HeadersValues.ParseRestAPIKey, forHTTPHeaderField: Constants.HeadersKeys.ParseRestAPIKey)
		
		// Step-4: Configure the request
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
	Realiza tareas comunes a todos los métodos POST de las solicitudes a la API de Parse.
	
	- parameter request: toma una solicitud POST determinada.
	
	- parameter completionHandlerForPOST: comprueba si la solicitud ha sido exitosa o no.
	
	*/
	
	func taskForPOSTMethod(_ request:NSMutableURLRequest, completionHandlerForPOST: @escaping (_ success: Bool, _ error: String?) -> Void) -> URLSessionDataTask {
	
		
		// Step-4: make the request
		let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
			
			// GUARD-a: if there was an error
			guard (error == nil) else {
				completionHandlerForPOST(false, Errors.Message.sessionRequestError.description)
				return
			}
			
			// GUARD-b: if response is not in success range
			guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
				completionHandlerForPOST(false, Errors.Message.sessionRequestError.description)
				return
			}
			
			// GUARD-c: if response is in server error range (500-599)
			guard let serverError = (response as? HTTPURLResponse)?.statusCode, serverError >= 200 && serverError <= 499 else {
				completionHandlerForPOST(false, error?.localizedDescription)
				return
			}
			
			// GUARD-d: if not data was returned
			guard data != nil else {
				completionHandlerForPOST(false, Errors.Message.sessionRequestDataError.description)
				return
			}

			// Step-5, 6: success
			completionHandlerForPOST(true, nil)
		}
		// Step-7: Start the request
		task.resume()
		
		return task
	}
	
	/**
	Configura la URL a enviar en las solicitudes web a la API de Parse.
	
	- parameter path: toma el 'path' de la solicitud.
	- parameter fromParameters: toma los parámetros (si es que los tiene) de la solicitud.
	
	- returns: devuelve la URL ya configurada.
	
	*/
	
	/**
	Configura la URL a enviar en las solicitudes web a la API de Parse.
	*/
	
	func url() -> URL {
		
		var components = URLComponents()
		components.scheme = Constants.ApiScheme
		components.host = Constants.ApiHost
		components.path = Constants.Methods.ApiPath
		
		return components.url!
	}
	
	func url(_ path: String, _ fromParameters: [String:AnyObject]? = nil) -> URL {
		
		var components = URLComponents()
		components.scheme = Constants.ApiScheme
		components.host = Constants.ApiHost
		components.path = path  
		components.queryItems = [URLQueryItem]()
		
		for (key, value) in fromParameters! {
			let queryItem = URLQueryItem(name: key, value: "\(value)")
			components.queryItems!.append(queryItem)
		}
		
		return components.url!
	}
	
	/**
	Configura el objeto json que irá en la solicitud web 'POSTing a Student Location'
	
	- parameter parameters: toma un diccionario de tipo '[String:AnyObject]' con los datos obtenidos de API de Udacity (clave única, nombre completo) y los datos ingresados por el mismo usuario.
	
	- returns: devuelve el objeto json ya configurado listo para enviar.
	
	*/
	
	func jsonRequestBody(_ parameters: [String:AnyObject]) -> Data {
		
		// Build JSON body (para la solicitud) from parameters
		let jsonBody: Data = "{\"\(Constants.JSONKeys.UniqueKey)\": \"\(parameters[Constants.JSONKeys.UniqueKey]!)\",\"\(Constants.JSONKeys.FirstName)\": \"\(parameters[Constants.JSONKeys.FirstName]!)\", \"\(Constants.JSONKeys.LastName)\": \"\(parameters[Constants.JSONKeys.LastName]!)\", \"\(Constants.JSONKeys.MapString)\": \"\(parameters[Constants.JSONKeys.MapString]!)\", \"\(Constants.JSONKeys.MediaURL)\": \"\(parameters[Constants.JSONKeys.MediaURL]!)\", \"\(Constants.JSONKeys.Latitude)\": \(parameters[Constants.JSONKeys.Latitude]!), \"\(Constants.JSONKeys.Longitude)\": \(parameters[Constants.JSONKeys.Longitude]!)}".data(using: String.Encoding.utf8)!

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
		var parsedResult: AnyObject! = nil
		do {
			parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
		} catch {
			completionHandlerForParsedData(false, Errors.Message.parseDataError.description, nil)
			return
		}
		// User parsed data
		completionHandlerForParsedData(true, nil, parsedResult)
	}
	
}

