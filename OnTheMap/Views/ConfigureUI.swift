//
//  ConfigureUI.swift
//  OnTheMap
//
//  Created by Luciano Schillagi on 9/11/17.
//  Copyright © 2017 Luko. All rights reserved.
//

/* View */

import UIKit

/*
Abstract:
Almacena todas las configuraciones de interfaz de usuario referentes a momentos de transición.
La interfaz de usuario queda inhabilitada y un 'activity indicator' se anima indicandole al usuario que debe esperar hasta que el proceso actual finalice. Cuando finaliza el proceso la interfaz vuelve a habilitarse y el 'activity indicator' desaparece.
*/

// MARK: - LoginViewController (Configure UI)

extension LoginViewController {
	
	// MARK: User Interface
	func setUIEnabled(_ enabled: Bool) {
		usernameTextField.isEnabled = enabled
		passwordTextField.isEnabled = enabled
		loginButton.isEnabled = enabled
		
		// adjust login button alpha
		if enabled {
			loginButton.alpha = 1.0
		} else {
			loginButton.alpha = 0.5
		}
	}
	
	// MARK: Animating
	func startAnimating() {
		
		activityIndicator.isHidden = false
		activityIndicator.startAnimating()
		self.view.alpha = 0.75
	}
	
	func stopAnimating() {
		
		activityIndicator.isHidden = true
		activityIndicator.stopAnimating()
		self.view.alpha = 1.0
	}
}

// MARK: - StudentLocationMapViewController (Configure UI)

extension StudentLocationMapViewController {
	
	// MARK: User Interface
	func setUIEnabled(_ enabled: Bool) {
		
		// adjust login button alpha
		if enabled {
			view.alpha = 1.0
		} else {
			view.alpha = 0.5
		}
	}
	
	// MARK: Animating
	func startAnimating() {
		
		activityIndicator.startAnimating()
		self.view.alpha = 0.75
	}
	
	func stopAnimating() {
		
		activityIndicator.stopAnimating()
		self.view.alpha = 1.0
	}
	
}

// MARK: - StudentLocationTableViewController (Configure UI)
extension StudentLocationTableViewController {
	
	// MARK: User Interface
	func setUIEnabled(_ enabled: Bool) {
		
		// adjust login button alpha
		if enabled {
			view.alpha = 1.0
		} else {
			view.alpha = 0.5
		}
	}
	
	// MARK: Animating
	func startAnimating() {
		
		activityIndicator.startAnimating()
		self.view.alpha = 0.75
	}
	
	func stopAnimating() {
		
		activityIndicator.stopAnimating()
		self.view.alpha = 1.0
	}

}

// MARK: - StudentInformationViewController (Configure UI)

extension StudentInformationViewController {
	
	// MARK: User Interface
	func setUIEnabled(_ enabled: Bool) {
		enterLocationTextField.isEnabled = enabled
		enterWebsiteTextField.isEnabled = enabled
		findLocationButton.isEnabled = enabled
		
		// adjust login button alpha
		if enabled {
			findLocationButton.alpha = 1.0
		} else {
			findLocationButton.alpha = 0.5
		}
	}
	
	// MARK: Animating
	func startAnimating() {
		
		activityIndicator.isHidden = false
		activityIndicator.startAnimating()
		self.view.alpha = 0.75
	}
	
	func stopAnimating() {
		
		activityIndicator.isHidden = true
		activityIndicator.stopAnimating()
		self.view.alpha = 1.0
	}
	
}

// MARK: - PostInformationViewController (Configure UI)

extension PostInformationViewController {
	
	// MARK: User Interface
	func setUIEnabled(_ enabled: Bool) {
		submitButton.isEnabled = enabled
		
		// adjust login button alpha
		if enabled {
			submitButton.alpha = 1.0
		} else {
			submitButton.alpha = 0.5
		}
	}
	
	// MARK: Animating
	func startAnimating() {
		
		activityIndicator.isHidden = false
		activityIndicator.startAnimating()
		self.view.alpha = 0.75
	}
	
	func stopAnimating() {
		
		activityIndicator.isHidden = true
		activityIndicator.stopAnimating()
		self.view.alpha = 1.0
	}
	
}
