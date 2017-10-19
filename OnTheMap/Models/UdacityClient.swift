//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Luciano Schillagi on 8/18/17.
//  Copyright © 2017 Luko. All rights reserved.
//

/* Model */

import Foundation

/*
Abstract:
Una clase preparada para recibir, mapear y almacenar datos del usuario obtenidos de la API de Udacity.
*/

// MARK: - Udacity API Client 

class Udacity : NSObject {
  
  // MARK: Properties
	let session = URLSession.shared
	var jsonData: AnyObject! = nil
	var sessionID: String? = nil
	var userID : String? = nil
	
	var firstName : String? = nil
	var lastName : String? = nil

  // MARK: Initializers
  override init() {
    super.init()
  }
	
}

