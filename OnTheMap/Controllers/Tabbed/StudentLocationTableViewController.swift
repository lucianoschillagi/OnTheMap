//
//  StudentLocationTableViewController.swift
//  OnTheMap
//
//  Created by Luciano Schillagi on 30/6/17.
//  Copyright © 2017 Luko. All rights reserved.
//

/* Controller */

import UIKit

/*
Abstract:
Este 'view controller' contiene una tabla con información acerca de cada estudiante, como su nombre y sitio web.
Si se tapea sobre alguna de las celdas la aplicación navegará hacia el sitio web de ese usuario.
*/

class StudentLocationTableViewController: UIViewController {
	
	// MARK: Properties
	static var student̊sTable: UITableView = UITableView()

	// MARK: - Outlets
	
    @IBOutlet weak var studentsInfoTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	
	// MARK: Life Cycle
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		getStudentsInformation()
		startAnimating()
	}
	
	override func viewDidLoad() {
		
		super.viewDidLoad()
		autolayoutTableVC()
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
		
		// refresh
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
						StudentLocationTableViewController.student̊sTable.reloadData()
						self.setUIEnabled(true)
						self.stopAnimating()
					} else {
						self.displayErrorAlert(Errors.Message.general.title, error)
					}
				} else {
					self.displayErrorAlert(Errors.Message.general.title, error)
				}
			}
		}
	}
	// end Reload >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

	
	// Add Student Information <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	
	/**
	Si el usuario desea cambiar su ubicación actual (en este caso específicamente crea una nueva ubicación) presionará el botón 'ADD'
	
	- Parameter sender: El objeto botón remite al controlador el mensaje de que ha sido presionado. El controlador reaccionará a ese evento y la aplicación navegará el 'student information view controller' (en este view controller el usuario podrá agregar una nueva ubicación y si lo desea, cambiar también su sitio web).
	*/
	
	@IBAction func addStudentInformation(_ sender: UIBarButtonItem) {
		
		// Reset UI
		self.setUIEnabled(false)
		self.startAnimating()
		getStudentNameAndExit()
		
	}
	// get student name and exit
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


// MARK: - Student Location Table View Delegate and Data Source

extension StudentLocationTableViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return StudentInformation.studentInformationStored.count
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 100
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		/* Get cell type */
		let cellReuseIdentifier = "StudentDetailCell"
		let studentDetail = StudentInformation.studentInformationStored[(indexPath as NSIndexPath).row]
		let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
		
		let firstName = studentDetail.firstName
		let lastName = studentDetail.lastName
		let fullname = ((firstName + " " + lastName))
		let url = studentDetail.mediaURL
		
		/* Set cell defaults */
		cell?.textLabel!.text = (fullname != "") ? fullname : "[No Name]"
		cell?.detailTextLabel?.text = (url != "") ? url : "[No Media URL]"
		cell?.imageView?.image = UIImage(named: "icon_pin")
		
		return cell!
	}
	
	func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
	
			let cell = tableView.cellForRow(at: indexPath)
			let url = URL(string:(cell?.detailTextLabel?.text)!)
	
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



