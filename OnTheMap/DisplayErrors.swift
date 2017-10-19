//
//  DisplayErrors.swift
//  OnTheMap
//
//  Created by Luciano Schillagi on 29/6/17.
//  Copyright © 2017 Luko. All rights reserved.
//

import Foundation

/*
Abstract:
Enumeración de los posibles errores a mostrar como mensajes dentro de 'Alerts Views' al usuario. El formato de estos mensajes es 'título' y 'descripción'.
*/

struct Errors {
    
    enum Message: Error {
        
        // Title
        case loginStatus
        case logoutStatus
        case accessStatus
        case updateStatus
        case general
        
        var title: String {
            switch self {
            case .loginStatus:
                return "Login Failed"
            case .logoutStatus:
                return "Logout Failed"
            case .accessStatus:
                return "Access Failed"
            case .updateStatus:
                return "Update Failed"
            case .general:
                return "Failed"
            default:
                return ""
            }
        }
        // Description
        case emptyCredentials
        case unauthorized
				case connectionFails
        case sessionRequestError
        case forbidden
        case sessionRequestDataError
        case parseDataError
        case sessionID
        case userID
        case getStudentsInformationError
        case openMediaURL
        case userInfo
        case emptyInput
        case notMediaURL
				case incorrectCredentials
        case invalidMediaURL
        case invalidLocation
        case createNewStudentLocationError
        
        var description: String {
            switch self {
            case .emptyCredentials:
                return "Empty Email or Password"
            case .unauthorized:
                return "Invalid Email or Password"
						case .connectionFails:
								return "Check your internet connection"
            case .sessionRequestError:
                return "There was an error with your request"
            case .forbidden:
                return "Your request returned a status code other than 2xx"
            case .sessionRequestDataError:
                return "No data was returned by the request"
            case .parseDataError:
                return "Could not parse the data as JSON"
            case .sessionID:
                return "User Session Not Created"
            case .userID:
                return "User ID Not Found"
            case .getStudentsInformationError:
                return "Could Not Get Students Information"
            case .openMediaURL:
                return "Invalid URL"
            case .userInfo:
                return "User Info Not Found"
            case .emptyInput:
                return "Empty Student Location or Media URL"
            case .notMediaURL:
                return "Not an URL"
						case .incorrectCredentials:
								return "Incorrect credentials"
            case .invalidMediaURL:
                return "URL Must Start With http(s)://"
            case .invalidLocation:
                return "No Matching Addresses Found"
            case .createNewStudentLocationError:
                return "Could Not Create New Student Location"
            default:
                return ""
				}
			}
		}
	}
