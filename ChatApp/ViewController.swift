//
//  ViewController.swift
//  ChatApp
//
//  Created by SKIXY-MACBOOK on 04/02/17.
//  Copyright © 2017 shubhamrathi. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UITableViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "logout", style: .plain, target: self, action: #selector(handlelogout))
	
		checkifUserisLoggedIn()
	}
	func checkifUserisLoggedIn(){
		if FIRAuth.auth()?.currentUser?.uid == nil {
			perform(#selector(handlelogout), with: nil, afterDelay: 0)
		}
		else{
			
		}
	}
	func handlelogout(){
	
		do {
			try FIRAuth.auth()?.signOut()
		}catch let error {
			print(error)
		}
		
		let loginController = LoginController()
		present(loginController, animated: true, completion: nil)
	}

}

