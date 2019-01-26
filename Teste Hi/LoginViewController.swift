//
//  LoginViewController.swift
//  Teste Hi
//
//  Created by Joao pedro Costa Miranda on 26/01/19.
//  Copyright © 2019 Joao. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate{

	@IBOutlet weak var userTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var errorLabel: UILabel!
	override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { 
	  	return .lightContent
	} 
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if textField == userTextField{
			passwordTextField.becomeFirstResponder()
			return true
		}else{
			if userTextField.text == "teste" && passwordTextField.text == "teste"{
				performSegue(withIdentifier: "loginSegue", sender: self)
			}else{
				errorLabel.text = "User/Password incorrect"
			}
			
			return true
		}
	}
    
}
