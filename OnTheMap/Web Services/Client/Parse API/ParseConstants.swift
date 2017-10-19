//
//  ParseConstants.swift
//  OnTheMap
//
//  Created by Luciano Schillagi on 8/18/17.
//  Copyright © 2017 Luko. All rights reserved.
//

/* Networking */

import Foundation

/*
Abstract:
Contiene los valores constantes a utilizarse en las solicitudes a la API de Parse.
*/

// MARK: - Parse API Constants

extension Parse {

	struct Constants {
	
	// MARK: Request
	
	static let ApiScheme = "https"
	static let ApiHost = "parse.udacity.com"
	
		struct MethodType {
			static let Post = "POST"
			static let Put = "PUT"
		}
		
		struct Methods   {
			static let ApiPath = "/parse/classes/StudentLocation"
			//static let ApiPathExtension = <objectID>
	}
	
		struct MethodParameterKeys {
			// Required
			static let Where = "where"
			static let UniqueKey = "uniqueKey"
			// Optionals
			static let Limit = "limit"
			static let Skip = "skip"
			static let Order = "order"
  }

		struct MethodParameterValues {
			// Required
			static let Where = Udacity.sharedInstance().userID  //<uniqueKey>
			// Optionals
			static let Limit = "100"
			static let Skip = "400"
			static let Order = "-updatedAt"
  }
		
		struct HeadersKeys {
			static let ParseApplicationID = "X-Parse-Application-Id"
			static let ParseRestAPIKey = "X-Parse-REST-API-Key"
			static let ContentType = "Content-Type"

  }

		struct HeadersValues {
			static let ParseApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
			static let ParseRestAPIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
			static let ApplicationJson = "application/json"

		}
  
	// MARK: Response
		
	// MARK: JSON Body Keys
		struct JSONKeys {
			static let Results = "results"
    
			// Student Info
			static let ObjectId = "objectId"
			static let UniqueKey = "uniqueKey"
			static let FirstName = "firstName"
			static let LastName = "lastName"
    
			// Student Location
			static let MapString = "mapString"
			static let Latitude = "latitude"
			static let Longitude = "longitude"
    
			// Student URL
			static let MediaURL = "mediaURL"
    
			// Student Permissions
			static let AccessControlList = "ACL"
    
			// Update Time
			static let CreatedAt = "createdAt"
			static let UpdatedAt = "updatedAt"
		}
	}
}
