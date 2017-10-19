//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Luciano Schillagi on 30/6/17.
//  Copyright © 2017 Luko. All rights reserved.
//

/* Controller */

import UIKit

/*
Abstract:
`LoginViewController` representa la pantalla de inicio donde el usuario se loguea con su cuenta de Udacity.
*/

class LoginViewController: UIViewController {
    
    // MARK: Properties
		var appDelegate: AppDelegate!
		var keyboardOnScreen = false
		override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: Outlets
		@IBOutlet weak var udacityLogo: UIImageView!
    @IBOutlet weak var loginToUdacityLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var dontHaveAccountLabel: UILabel!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: Life Cycle
		override func viewDidLoad() {
			super.viewDidLoad()

			activityIndicator.isHidden = true
			
			// get the app delegate
			appDelegate = UIApplication.shared.delegate as! AppDelegate
			
				subscribeToNotification(.UIKeyboardWillShow, selector: #selector(keyboardWillShow))
				subscribeToNotification(.UIKeyboardWillHide, selector: #selector(keyboardWillHide))
        subscribeToNotification(.UIKeyboardDidShow, selector: #selector(keyboardDidShow))
        subscribeToNotification(.UIKeyboardDidHide, selector: #selector(keyboardDidHide))
        
				autolayoutLogin()
    }
    
		override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUIEnabled(true)
        stopAnimating()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopAnimating()
        unsubscribeFromAllNotifications()
    }
    
  // MARK: Login
  
  /**
   Inicia el proceso de logueo cuando el usuario presiona el botón 'LOGIN'.
	
   - Parameter sender: El objeto botón remite al controlador el mensaje de que ha sido presionado (el controlador reaccionará a ese evento)
   */
	
	// Login <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
		@IBAction func loginPressed(_ sender: UIButton) {

        view.endEditing(true)
        setUIEnabled(false)
        startAnimating()
			
        if usernameTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
					self.displayErrorAlert(Errors.Message.loginStatus.title.description, Errors.Message.emptyCredentials.description)
        } else {
				
					let parameters: [String:String] = [
						Udacity.Constants.JSONBodyKeys.Username: usernameTextField.text!,
						Udacity.Constants.JSONBodyKeys.Password: passwordTextField.text! 
					]
			
					Udacity.sharedInstance().loginWithID(parameters) { (success, error) in
						performUIUpdatesOnMain {
							if success {
								self.completeLogin()
							} else {
								self.displayErrorAlert(Errors.Message.loginStatus.title, error)
						}
					}
				}
			}
		}
	
    func completeLogin() {
			
      performUIUpdatesOnMain {
        // Enable UI and prepare to exit
        self.setUIEnabled(true)
        // Present student location views
				let controller = self.storyboard!.instantiateViewController(withIdentifier: "SLTabbedView")
				self.present(controller, animated: true, completion: nil)
      }
	}
	// end Login >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

	/**
	Cuando el usuario presiona el botón 'SIGN UP' la aplicación navega hacia el sitio web de Udacity, donde podrá crear una cuenta para luego poder loguerse.
	
	- Parameter sender: El objeto botón remite al controlador el mensaje de que ha sido presionado. El controlador reaccionará a ese evento y la aplicación navegará hacia el
	*/
	
		@IBAction func signupToUdacity(_ sender: UIButton) {
		
        // Dismiss keyboard and prepare to signup
        view.endEditing(true)
			
        // Open Udacity signup page in Safari
			if let url = URL(string: Udacity.Constants.SignUpURL) {
					UIApplication.shared.open(url, options: [:], completionHandler: nil)
			}
    }
	
		// MARK: Display Error (Alert Controller)
	
	/**
	Muestra al usuario un mensaje acerca de cual ha sido el error en el su proceso de logueo.
	
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

// MARK: - LoginViewController (UITextFieldDelegate)

extension LoginViewController: UITextFieldDelegate {
	
	// MARK: UITextFieldDelegate
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
	
	// MARK: Show/Hide Keyboard
	func keyboardWillShow(_ notification: Notification) {
		if !keyboardOnScreen {
			view.frame.origin.y -= keyboardHeight(notification)
			udacityLogo.isHidden = true
		}
	}
	
	func keyboardWillHide(_ notification: Notification) {
		if keyboardOnScreen {
			view.frame.origin.y += keyboardHeight(notification)
			udacityLogo.isHidden = false
		}
	}
	
	func keyboardDidShow(_ notification: Notification) {
		keyboardOnScreen = true
	}
	
	func keyboardDidHide(_ notification: Notification) {
		keyboardOnScreen = false
	}
	
	private func resignIfFirstResponder(_ textField: UITextField) {
		if textField.isFirstResponder {
			textField.resignFirstResponder()
		}
	}
	
	// MARK: Keyboard Height
	private func keyboardHeight(_ notification: Notification) -> CGFloat {
		let userInfo = (notification as NSNotification).userInfo
		let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
		return keyboardSize.cgRectValue.height
	}
	
	// MARK: Tap Gesture Recognizer
	@IBAction func userDidTapView(_ sender: AnyObject) {
		resignIfFirstResponder(usernameTextField)
		resignIfFirstResponder(passwordTextField)
	}
}

	// MARK: - LoginViewController (Notifications)

	private extension LoginViewController {
	
	func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector) {
		NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
	}
	
	func unsubscribeFromAllNotifications() {
		NotificationCenter.default.removeObserver(self)
	}
}




