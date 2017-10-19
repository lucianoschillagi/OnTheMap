//
//  StudentLocationMapViewController.swift
//  OnTheMap
//
//  Created by Luciano Schillagi on 30/6/17.
//  Copyright © 2017 Luko. All rights reserved.
//

/* Controller */

import UIKit
import MapKit

/*
Abstract:
Este 'view controller' contiene la vista de un mapa donde la ubicación de cada usuario es representada por un pin.
Si se tapea sobre alguno de los pines, se despliega información adicional sobre el usuario, como su nombre y sitio web.
*/

class StudentLocationMapViewController: UIViewController {

	// MARK: Properties
	static var studentsMap: MKMapView = MKMapView()
	
	// MARK: Outlets
	@IBOutlet weak var studentsMap: MKMapView!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!

	// MARK: Life Cycle
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		getStudentsInformation()
		startAnimating()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		autolayoutMapVC()
		
		// Intialize
		StudentLocationMapViewController.studentsMap = studentsMap
	}
	
	override func viewDidAppear(_ animated: Bool) {
		setUIEnabled(true)
		stopAnimating()
	}

	// MARK: - User Actions
	
	// Logout <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	
	/**
	Al tapear el botón 'LOGOUT' el usuario finaliza su sesión.
	
	- Parameter sender: El objeto botón remite al controlador el mensaje de que ha sido presionado. El controlador reaccionará a ese evento y la aplicación navegará hacia la pantalla de inicio.
	*/
	
	@IBAction func logoutPressed(_ sender: UIBarButtonItem) {
		
		Udacity.sharedInstance().deleteSession { (success, error) in
			performUIUpdatesOnMain {
				if success {
					self.completeLogout()
				} else {
					self.displayErrorAlert(Errors.Message.logoutStatus.title, error)
				}
			}
		}
	}
	
	func completeLogout() {
		// enable UI and prepare to exit
		setUIEnabled(true)
		self.dismiss(animated: true, completion: nil)
	}
	// end Logout >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	
	
	// Reload Student List <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	
	/**
	Al tapear el botón 'RELOAD' el controlador volverá a cargarse actualizando los datos de las ubicaciones de los estudiantes.
	
	- Parameter sender: El objeto botón remite al controlador el mensaje de que ha sido presionado. El controlador reaccionará a ese evento volviéndose a cargar.
	*/
	
	@IBAction func reloadStudentList(_ sender: UIBarButtonItem) {
		
		setUIEnabled(false)
		startAnimating()
		getStudentsInformation()
	}

	func getStudentsInformation() {
		
		// Get current information
		Parse.sharedInstance().getStudentsInformation { ( success, error, studentInformation) in
			performUIUpdatesOnMain {
				if success {
					if let studentInformation = studentInformation {
						StudentInformation.studentInformationStored = studentInformation
						StudentLocationMapViewController().reloadMapView()
						self.setUIEnabled(true)
						self.stopAnimating()
					} else {
						self.displayErrorAlert(Errors.Message.updateStatus.title, error)
					}
				} else {
					self.displayErrorAlert(Errors.Message.updateStatus.title, error)
				}
			}
		}
	}
	// end Reload >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

	
	// Add Student Information <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	
	/**
	Si el usuario desea cambiar su ubicación actual (en este caso específicamente crea una nueva ubicación) presionará el botón 'ADD'
	
	- Parameter sender: El objeto botón remite al controlador el mensaje de que ha sido presionado. El controlador reaccionará a ese evento y la aplicación navegará al 'student information view controller' (en este view controller el usuario podrá agregar una nueva ubicación y si lo desea, cambiar también su sitio web).
	*/
	
	@IBAction func addStudentInformation(_ sender: UIBarButtonItem) {

		// Reset UI
		self.setUIEnabled(false)
		self.startAnimating()
		getStudentNameAndExit()
		
	}

	func getStudentNameAndExit(){
	
		// get student name
		Udacity.sharedInstance().getStudentName { (success, error) in
			if success {
				// Alert Controller
				let alertController = UIAlertController(title: "", message: "User '\(Udacity.sharedInstance().firstName ?? "") \(Udacity.sharedInstance().lastName ?? "")' Has Already Posted a Student Location. Would You Like to Overwrite Their Location?", preferredStyle: .alert)
				
				let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
					self.setUIEnabled(true)
					self.stopAnimating()
				}
				alertController.addAction(cancelAction)
				
				let OKAction = UIAlertAction(title: "Overwrite", style: .default) { action in
					
					// Present student location views
					let controller = self.storyboard!.instantiateViewController(withIdentifier: "Relocation") as! UINavigationController
					self.present(controller, animated: true, completion: nil)
				}
				alertController.addAction(OKAction)
				
				self.present(alertController, animated: true)
				
				} else {
				self.displayErrorAlert(Errors.Message.general.title, error)
				
			}
		}
	}
	// end 'Add Student Information' >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

	// MARK: Class Functions
	
	/**
	Carga nuevamente la vista del mapa y los pines de los estudiantes.
	*/
	
	func reloadMapView() {
		
		let studentsLocation = StudentInformation.studentInformationStored
		var annotations = [MKPointAnnotation]()
		
		for studentLocation in studentsLocation {
			
			let lat = CLLocationDegrees(studentLocation.latitude)
			let long = CLLocationDegrees(studentLocation.longitude)
			let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
			
			let first = studentLocation.firstName
			let last = studentLocation.lastName
			let url = studentLocation.mediaURL
			
			let annotation = MKPointAnnotation()
			annotation.coordinate = coordinate
			annotation.title = "\(first) \(last)"
			annotation.subtitle = url
			
			annotations.append(annotation)
		}
		
		StudentLocationMapViewController.studentsMap.addAnnotations(annotations)
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

// MARK: Student Location MapKit Delegate
extension StudentLocationMapViewController: MKMapViewDelegate {
	
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		
		let reuseId = "pin"
		
		var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
		
		if pinView == nil {
			pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
			pinView!.canShowCallout = true
			pinView!.pinTintColor = .red
			pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
		}
		else {
			pinView!.annotation = annotation
		}
		
		return pinView
	}
	
	func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
		
		if control == view.rightCalloutAccessoryView {
			let url = URL(string: (view.annotation?.subtitle!)!)
			
			// GUARD if no URL was returned
			guard (url != nil) else {
				displayErrorAlert(Errors.Message.accessStatus.title.description, Errors.Message.openMediaURL.description)
				return
			}
			
			// Display media link in Safari
			if UIApplication.shared.canOpenURL(url!) {
				UIApplication.shared.open(url!, options: [:], completionHandler: nil)
			} else {
				displayErrorAlert(Errors.Message.accessStatus.title.description, Errors.Message.openMediaURL.description)
			}
		}
	}
	
}




