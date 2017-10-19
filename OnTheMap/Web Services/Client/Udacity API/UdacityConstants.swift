//
//  UdacityConstants.swift
//  OnTheMap
//
//  Created by Luciano Schillagi on 8/18/17.
//  Copyright © 2017 Luko. All rights reserved.
//

/* Networking */

import Foundation

/*
Abstract:
Contiene los valores constantes a utilizarse en las solicitudes a la API de Udacity.
*/

// MARK: - Udacity API Constants

extension Udacity {

	struct Constants {
	
		// MARK: Request
		
		static let SignUpURL = "https://udacity.com/account/auth#!/signup"
		static let ApiScheme = "https"
		static let ApiHost = "www.udacity.com"
	
			struct MethodType {
				static let Post = "POST"
				static let Delete = "DELETE"
	}
		
			struct Methods   {
				static let ApiPathSession = "/api/session"
				static let ApiPathUsers = "/api/users"
	}
	
			struct HeadersKeys {
				static let Accept = "Accept"
				static let ContentType = "Content-Type"
				static let XXsrfToken = "X-XSRF-TOKEN"
  }

			struct HeadersValues {
				static let ApplicationJson = "application/json"
				static let CookieNameXSRF = "XSRF-TOKEN"
		}

			struct JSONBodyKeys {
				static let Udacity = "udacity"
				static let Username = "username"
				static let Password = "password"
  }
	
		// MARK: Response
	
		// MARK: JSON Body Keys
		struct JSONResponseKeys {
		
			// POSTing a Session
			// Account
			static let Account = "account"
			static let Registered = "registered"
			static let UserID = "key"
			static let FirstName = "first_name"
			static let LastName = "last_name"

			// Session
			static let Session = "session"
			static let SessionID = "id"
			static let Expiration = "expiration"
		
			// GETting Public User Data
			// User
			static let UserInfo = "user"
			static let Bio = "bio"
			static let _Registered = "_registered"
			static let Linkedin = "linkedin_url"
			static let Image = "_image"
			static let Guard = "guard"
			static let AllowedBehaviors = "allowed_behaviors"
			static let Register = "register"
			static let ViewPublic = "view-public"
			static let ViewShort = "view-short"
			static let Location = "location"
			static let Timezone = "timezone"
			static let ImageURL = "_image_url"
			static let Nickname = "nickname"
			static let WebsiteURL = "website_url"
			static let Occuparion = "occupation"
		}
	}
}
