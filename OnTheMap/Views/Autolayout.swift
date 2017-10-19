//
//  Autolayout.swift
//  OnTheMap
//
//  Created by Luciano Schillagi on 29/6/17.
//  Copyright © 2017 Luko. All rights reserved.
//

/* View */

import SnapKit

/*
Abstract:
Crea las restricciones para todos los elementos visuales de la interfaz de usuario.
Almacena las restricciones de los todos view controllers.
*/

extension LoginViewController {
    
    func autolayoutLogin() {
        
        // addViews for SnapKit
        self.view.addSubview(udacityLogo)
        self.view.addSubview(loginToUdacityLabel)
				self.view.addSubview(usernameTextField)
				self.view.addSubview(passwordTextField)
        self.view.addSubview(loginButton)
        self.view.addSubview(signupButton)
        self.view.addSubview(dontHaveAccountLabel)
        self.view.addSubview(activityIndicator)
        
        // Autolayout - Constraints
        udacityLogo.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(70)
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view).offset(-130)
        }
        
        loginToUdacityLabel.snp.makeConstraints{ (make) -> Void in
            make.width.equalTo(210)
            make.height.equalTo(45)
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view).offset(-50)
        }
        
        usernameTextField.snp.makeConstraints{ (make) -> Void in
            make.width.equalTo(250)
            make.height.equalTo(45)
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view).offset(0)
        }
        
        passwordTextField.snp.makeConstraints{ (make) -> Void in
            make.width.equalTo(250)
            make.height.equalTo(45)
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view).offset(55)
        }
        
        loginButton.snp.makeConstraints{ (make) -> Void in
            make.width.equalTo(250)
            make.height.equalTo(45)
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view).offset(122)
        }
        
        dontHaveAccountLabel.snp.makeConstraints{ (make) -> Void in
            make.centerX.equalTo(self.view).offset(-30)
            make.centerY.equalTo(self.view).offset(170)
            
        }
        
        signupButton.snp.makeConstraints{ (make) -> Void in
            make.centerX.equalTo(self.view).offset(95)
            make.centerY.equalTo(self.view).offset(170)
        }
        
        activityIndicator.snp.makeConstraints{ (make) -> Void in
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view)
        }
			}
}

extension StudentLocationMapViewController {
    
    func autolayoutMapVC() {
        
        // addViews for SnapKit
        self.view.addSubview(activityIndicator)
        
        // Autolayout - Constraints
        activityIndicator.snp.makeConstraints{ (make) -> Void in
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view)
        }
    }
}

extension StudentLocationTableViewController {
    
    func autolayoutTableVC() {
        
        // addViews for SnapKit
        self.view.addSubview(activityIndicator)
        
        // Autolayout - Constraints
        activityIndicator.snp.makeConstraints{ (make) -> Void in
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view)
        }
    }
}

extension StudentInformationViewController {
	
	func autolayoutStudentInformation() {
		
		// addViews for SnapKit
		self.view.addSubview(iconRelocation)
		self.view.addSubview(enterLocationTextField)
		self.view.addSubview(enterWebsiteTextField)
		self.view.addSubview(findLocationButton)
		self.view.addSubview(activityIndicator)
		
		// Autolayout - Constraints
		iconRelocation.snp.makeConstraints { (make) -> Void in
			make.width.height.equalTo(70)
			make.centerX.equalTo(self.view)
			make.centerY.equalTo(self.view).offset(-150)
		}
		
		enterLocationTextField.snp.makeConstraints{ (make) -> Void in
			make.width.equalTo(250)
			make.height.equalTo(45)
			make.centerX.equalTo(self.view)
			make.centerY.equalTo(self.view).offset(-70)
		}
		
		enterWebsiteTextField.snp.makeConstraints{ (make) -> Void in
			make.width.equalTo(250)
			make.height.equalTo(45)
			make.centerX.equalTo(self.view)
			make.centerY.equalTo(self.view).offset(-15)
		}
		
		findLocationButton.snp.makeConstraints{ (make) -> Void in
			make.width.equalTo(250)
			make.height.equalTo(45)
			make.centerX.equalTo(self.view)
			make.centerY.equalTo(self.view).offset(42)
		}
		
		activityIndicator.snp.makeConstraints { (make) -> Void in
			make.centerX.equalTo(self.view)
			make.centerY.equalTo(self.view)
		}
	}
}

extension PostInformationViewController {
	
	func autolayoutPostInformation() {
		
		// addViews for SnapKit
		self.view.addSubview(submitButton)
		self.view.addSubview(activityIndicator)
		
		// Autolayout - Constraints
		submitButton.snp.makeConstraints{ (make) -> Void in
			// size
			make.width.equalTo(250)
			make.height.equalTo(45)
			// location
			make.centerX.equalTo(self.view)
			make.bottom.equalTo(self.view).offset(-20)
		}
		
		activityIndicator.snp.makeConstraints{ (make) -> Void in
			make.centerX.equalTo(self.view)
			make.centerY.equalTo(self.view)
		}
	}
}
