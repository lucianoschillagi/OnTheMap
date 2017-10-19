//
//  StudentInformationViewController.swift
//  OnTheMap
//
//  Created by Luciano Schillagi on 30/6/17.
//  Copyright © 2017 Luko. All rights reserved.
//

/* Controller */

import UIKit
import CoreLocation

/*
Abstract:
Mediante este 'view controller' el usuario podrá ingresar una ubicación y sitio web nuevo.
*/

class StudentInformationViewController: UIViewController {
    
	// MARK: Properties
	
	var appDelegate: AppDelegate!
	var keyboardOnScreen = false
	
	// almaceno los datos obtenidos mediantes las funciones getMediaURL y getGeoLocation para luego utilizarlos
	// son datos necesarios para mostrar la nueva ubicación de un estudiante en el siguiente VC (PostInformationVC)
	static var mapString: String = String()
	static var latitude: Double = Double()
	static var longitude: Double = Double()
	static var mediaURL: String = String()
    
    // MARK: Outlets
    @IBOutlet weak var iconRelocation: UIImageView!
    @IBOutlet weak var enterLocationTextField: UITextField!
    @IBOutlet weak var enterWebsiteTextField: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
		@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
		
		activityIndicator.isHidden = true
        // get the app delegate
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        autolayoutStudentInformation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Layout
        setUIEnabled(true)
				stopAnimating()
	}
	
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopAnimating()
        unsubscribeFromAllNotifications()
    }

	// MARK: User Actions
	
	/**
	Al tapear el botón 'FIND LOCATION' el usuario envía los datos recientemente ingresados y navega hacia la próxima pantalla (donde un pin estará sobre su nueva ubicación)
	
	- Parameter sender: El objeto botón remite al controlador el mensaje de que ha sido presionado (el controlador reaccionará a ese evento)
	*/
	
    @IBAction func findStudentCurrentLocation(_ sender: UIButton) {
			// Enable UI and prepare to exit
			view.endEditing(true)
			setUIEnabled(false)
			startAnimating()
		
				// Verify inputs not empty
				verifyInput() { (success, error) in
				if success {
				
					// Success: verify URL and get media string
					self.getMediaURL() { (success, error) in
						if success {
						
							// Success: verify address adn get coordinates for location
							self.getGeoLocation() { (success, error) in
								if success {
									// Success: Present 'AddLocationViewController'
									let controller = self.storyboard!.instantiateViewController(withIdentifier: "Post Information View Controller") as! UINavigationController
										self.present(controller, animated: true, completion: nil)
								} else {
									self.displayErrorAlert(Errors.Message.general.title.description, error)
								}
							}
						} else {
							self.displayErrorAlert(Errors.Message.general.title.description, error)
						}
					}
				} else {
					self.displayErrorAlert(Errors.Message.general.title.description, error)
			}
		}
	}
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
		
        view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }	
	
	// MARK: Class Functions
	
	/**
	Verifica que el usuario haya completado los campos de texto 'enterLocationTextField' y 'enterWebsiteTextField'.
	
	- Parameter completionHandlerForInput: Contiene como parámetro un 'completion handler' informándole al controlador si la condición se cumple o no.
	*/
	
	func verifyInput(completionHandlerForInput: @escaping (_ success: Bool, _ error: String?) -> Void) {
		
		// Verify if location and media URL are entered
		if enterLocationTextField.text!.isEmpty || enterWebsiteTextField.text!.isEmpty {
			completionHandlerForInput(false, Errors.Message.emptyInput.description)
		} else {
			completionHandlerForInput(true, nil)
		}
	  }
	
	/**
	Obtiene la 'mediaURL' del usuario (su sitio web)
	
	- Parameter completionHandlerForMediaURL: Contiene como parámetro un 'completion handler' informándole al controlador se obtuvo el dato requerido o no.
	*/
	
	func getMediaURL(completionHandlerForMediaURL: @escaping (_ success: Bool, _ error: String?) -> Void) {
		
		let url =  URL(string: enterWebsiteTextField.text!)
		//AddLocationViewController.mediaURL = url
		
		// GUARD if not URL was returned
		guard (url != nil) else {
			completionHandlerForMediaURL(false, Errors.Message.invalidMediaURL.description)
			return
		}
		
		// Verify and save valid URL
		if UIApplication.shared.canOpenURL(url!) {
			StudentInformationViewController.mediaURL = (url?.absoluteString)!
			completionHandlerForMediaURL(true,nil)
		} else {
			completionHandlerForMediaURL(false, Errors.Message.invalidMediaURL.description)
		}
	}
	
	/**
	Obtiene el 'enterLocationTextField' del usuario (el nombre de la ciudad de la nueva ubicación del estudiante).
	
	- Parameter completionHandlerForGeoLocation: Contiene como parámetro un 'completion handler' informándole al controlador se obtuvo el dato requerido o no.
	*/
	
	func getGeoLocation(completionHandlerForGeoLocation: @escaping (_ success: Bool, _ error: String?) -> Void) {
		
		let address = enterLocationTextField.text!
		
		CLGeocoder().geocodeAddressString(address, completionHandler: { (placemarks, error) in
			
		  // GUARD if no location was returned
			guard (error == nil) else {
				completionHandlerForGeoLocation(false, Errors.Message.invalidLocation.description)
				return
			}
			
			// Save location details
			if (placemarks?.count)! > 0 {
				let placemark = placemarks?[0]
				let location = placemark?.location
				let coordinate = location?.coordinate
				
				StudentInformationViewController.mapString = self.enterLocationTextField.text!
				StudentInformationViewController.latitude = coordinate!.latitude
				StudentInformationViewController.longitude = coordinate!.longitude
				
				completionHandlerForGeoLocation(true, nil)
			  }
		} )
  }
	
	// MARK: Display Error (Alert Controller)
	
	/**
	Muestra al usuario un mensaje acerca de cual ha sido el error ocurrido.
	
	- Parameter title: El título del error.
	- Parameter message: El mensaje acerca del error.
	
	*/
	
	func displayErrorAlert(_ title: String?, _ message: String?) {
		
		// Reset UI
		setUIEnabled(true)
		stopAnimating()
		
		// Display Error in Alert Controller
		let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
		alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
		self.present(alert, animated: true, completion: nil)
	}
	
} // en VC

// MARK: - AddLocationViewController (UITextFieldDelegate)

extension StudentInformationViewController: UITextFieldDelegate {
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
	
    private func resignIfFirstResponder(_ textField: UITextField) {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
    }
	
    // MARK: Tap Gesture Recognizer
    @IBAction func userDidTapView(_ sender: AnyObject) {
        resignIfFirstResponder(enterLocationTextField)
        resignIfFirstResponder(enterWebsiteTextField)
    }
}

// MARK: - AddLocationViewController (Notifications)

private extension StudentInformationViewController {
    
    func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    func unsubscribeFromAllNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
}


