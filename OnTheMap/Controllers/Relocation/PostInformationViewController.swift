//
//  PostInformationViewController.swift
//  OnTheMap
//
//  Created by Luciano Schillagi on 30/6/17.
//  Copyright © 2017 Luko. All rights reserved.
//

/* Controller */

import UIKit
import MapKit
import CoreLocation

/*
Abstract:
En este 'view controller' el usuario verá, representada por un pin, a su nueva ubicación en el mapa.
Luego podrá tapear el botón 'SUBMIT' para navegar hacia la vista global del mapa, donde verá reflejada su nueva ubicación en un pin así como la ubicación de todos los demás estudiantes.
*/

class PostInformationViewController: UIViewController {
	
		// MARK: - Properties
		var parameters: [String: AnyObject] = [String:AnyObject]()
	
    // MARK: - Outlets
    @IBOutlet weak var studentLocationMap: MKMapView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
	// MARK: - Life Cycle
	override func viewDidLoad() {
			super.viewDidLoad()
        
			autolayoutPostInformation()
			setParameters()
	}
	
	override func viewWillAppear(_ animated:Bool) {
		
		super.viewWillAppear(animated)
		startAnimating()
		setAnnotation()
	}
	
	override func viewDidAppear(_ animated:Bool) {
		
		super.viewWillAppear(animated)
		stopAnimating()
		
	}

	// MARK: - User Actions
	
	/**
	Envía al servidor de Parse un objeto nuevo (que contiene los datos recientes ingresados por el usuario)
	
	- Parameter sender: El objeto botón remite al controlador el mensaje de que ha sido presionado (el controlador reaccionará a ese evento)
	*/
	
	@IBAction func submitStudenInformation(_ sender: UIButton) {
		
		// Prepare to submit student information
		startAnimating()
		studentLocationMap.deselectAnnotation(studentLocationMap.annotations[0], animated: true)
		
		// Add new location and media URL
		Parse.sharedInstance().createNewStudentLocation(parameters) { (success, error) in
			performUIUpdatesOnMain {
				if success {
					let presentingViewController: UIViewController! = self.presentingViewController
					self.dismiss(animated: false) {
						presentingViewController.dismiss(animated: true , completion: nil)
					}
				} else {
					self.displayErrorAlert(Errors.Message.updateStatus.title.description, error)
				}
			}
		}
	}
	
	/**
	Al tapear el botón 'CANCEL' el usuario cancela la posibilidad de ingresar sus nuevos datos y navega hacia el 'view controller' anterior.
	
	- Parameter sender: El objeto botón remite al controlador el mensaje de que ha sido presionado (el controlador reaccionará a ese evento)
	*/
	
		@IBAction func cancelInformationPosting(_ sender: UIBarButtonItem) {
		
			view.endEditing(true)
			setUIEnabled(false)
			studentLocationMap.deselectAnnotation(studentLocationMap.annotations[0], animated:(true))
			self.dismiss(animated: true, completion: nil)
	}

	// MARK: - Class Functions
	
	/**
	Mapea los datos obtenidos almacenados en la estructura 'StudentInformation'.
	NOTA: al inicializar el objeto 'StudentInformation' se le asignó a todas sus claves las mismas claves que contiene el objeto parse 'StudentLocation'.
	*/
	
	func setParameters() {
		
		// Stop-1: Set the parameters (para pasar luego como datos json del método...
		parameters = [
			Parse.Constants.JSONKeys.UniqueKey : Udacity.sharedInstance().userID as AnyObject,
			Parse.Constants.JSONKeys.FirstName : Udacity.sharedInstance().firstName as AnyObject,
			Parse.Constants.JSONKeys.LastName : Udacity.sharedInstance().lastName as AnyObject,
			Parse.Constants.JSONKeys.MapString : StudentInformationViewController.mapString as AnyObject,
			Parse.Constants.JSONKeys.Latitude: StudentInformationViewController.latitude as AnyObject,
			Parse.Constants.JSONKeys.Longitude: StudentInformationViewController.longitude as AnyObject,
			Parse.Constants.JSONKeys.MediaURL: StudentInformationViewController.mediaURL as AnyObject
		]
	}

	/**
	Pone el pin con la nueva ubicación ingresada por el usuario.
	*/
	func setAnnotation() {
		
		// Set annotationn (pin)
		let latitude = CLLocationDegrees(parameters[Parse.Constants.JSONKeys.Latitude] as! Double)
		let latitudeDelta : CLLocationDegrees = 1/180.0
		
		let longitude = CLLocationDegrees(parameters[Parse.Constants.JSONKeys.Longitude] as! Double)
		let longitudeDelta: CLLocationDegrees = 1/180.0
		
		let centerCoordiante = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
		let span = MKCoordinateSpanMake(latitudeDelta, longitudeDelta)
		
		let coordinateRegion = MKCoordinateRegionMake(centerCoordiante, span)
		studentLocationMap.setRegion(coordinateRegion, animated: true)
		
		var address: String = (parameters[Parse.Constants.JSONKeys.MapString])!.trimmingCharacters(in: .whitespaces).capitalized
		address = (address != "") ? address : "[No Address]"
		
		var url: String = (parameters[Parse.Constants.JSONKeys.MediaURL])!.trimmingCharacters(in: .whitespaces).lowercased()
		url = (url != "") ? url : "[No Media URL]"

		// Add and display annotation
		let annotation = MKPointAnnotation()
		annotation.coordinate = centerCoordiante
		annotation.title = address
		annotation.subtitle = url
		studentLocationMap.addAnnotation(annotation)
		studentLocationMap.selectAnnotation(studentLocationMap.annotations[0], animated: true)
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

} // end VC
