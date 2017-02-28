//
//  LoginController.swift
//  ChatApp
//
//  Created by SKIXY-MACBOOK on 04/02/17.
//  Copyright © 2017 shubhamrathi. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController{
	

	let nameTextField: UITextField = {
		let tf = UITextField()
		tf.placeholder = "Name"
		tf.translatesAutoresizingMaskIntoConstraints = false
		return tf
	}()
	
	let nameSeperatorView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor.gray
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	let emailTextField: UITextField = {
		let tf = UITextField()
		tf.placeholder = "Email"
		tf.translatesAutoresizingMaskIntoConstraints = false
		return tf
	}()
	
	let emailSeperatorView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor.gray
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	let passwordTextField: UITextField = {
		let tf = UITextField()
		tf.placeholder = "Password"
		tf.translatesAutoresizingMaskIntoConstraints = false
		tf.isSecureTextEntry = true
		return tf
	}()
	
	
	let inputContainerView:  UIView = {
		let view  = UIView()
		view.backgroundColor = UIColor.white
		view.translatesAutoresizingMaskIntoConstraints = false
		view.layer.cornerRadius = 5
		view.layer.masksToBounds = true
		return view
	}()
	
	let loginButton: UIButton = {
		let button = UIButton(type: .system)
		button.backgroundColor = UIColor(red: 80/255, green: 101/255, blue: 161/255, alpha: 1)
		button.setTitle("Register", for: .normal)
		button.setTitleColor(UIColor.white, for: .normal)
		button.layer.cornerRadius = 5
		button.layer.masksToBounds = true
		button.translatesAutoresizingMaskIntoConstraints = false
		button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
		return button
	}()
	
	let loginRegisterSegmentedControl : UISegmentedControl = {
		let control = UISegmentedControl(items:["login","Register"])
		control.translatesAutoresizingMaskIntoConstraints = false
		control.tintColor = UIColor.white
		control.selectedSegmentIndex = 1
		
		control.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
		return control
	}()
	
	func handleLoginRegisterChange(){
		let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
		loginButton.setTitle(title, for: .normal)
		
		//change height of inputContainerView
		inputContainerHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ?100:150
		
		//change multiplier of nameTextField
		nameTextFieldHeightAnchor?.isActive = false
		nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex  == 0 ? 0 : 1 / 3)
		nameTextField.placeholder = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ?  "":"Name"
		nameTextFieldHeightAnchor?.isActive = true
		
		emailTextFieldHeightAnchor?.isActive = false
		emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex  == 0 ? 1/2: 1 / 3)
		emailTextFieldHeightAnchor?.isActive = true
		
		passwordTextFieldHeightAnchor?.isActive = false
		passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex  == 0 ? 1/2: 1 / 3)
		passwordTextFieldHeightAnchor?.isActive = true
		
	}
	func handleLoginRegister(){
		loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? loginClicked() : RegisterClicked()
	}
	
	func loginClicked(){
		guard let email = emailTextField.text,let password = passwordTextField.text else {
			print("String Invalid")
			return
		}
		FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
			if error != nil {
				print(error!)
				return
			}
			self.dismiss(animated: true, completion: nil)
		})
	}
	func RegisterClicked(){
		guard let email = emailTextField.text,let password = passwordTextField.text , let name = nameTextField.text else {
			print("String Invalid")
			return
		}
		FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user:FIRUser?, error) in
			if error != nil{
				print(error!)
				return
			}
			guard let uid = user?.uid else{
				return
			}
			//successfully authenticated user
			let ref = FIRDatabase.database().reference(fromURL: "https://chatapp-4e94f.firebaseio.com/")
			let usersReference = ref.child("users").child(uid)
			let values = ["name":name,"password":password,"email":email]
			usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
			
				if err != nil {
					return
				}
				
				self.dismiss(animated: true, completion: nil)
				
			})
			
		})
		
	}
	
	var inputContainerHeightAnchor: NSLayoutConstraint?
	var nameTextFieldHeightAnchor: NSLayoutConstraint?
	var emailTextFieldHeightAnchor: NSLayoutConstraint?
	var passwordTextFieldHeightAnchor: NSLayoutConstraint?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = UIColor(red: 61/255, green: 91/255, blue: 151/255, alpha: 1)
		let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
		tap.cancelsTouchesInView = false
		self.view.addGestureRecognizer(tap)

		view.addSubview(inputContainerView)
		view.addSubview(loginButton)
		view.addSubview(loginRegisterSegmentedControl)
		
		inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
		inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1,constant:-24).isActive = true
		
		inputContainerHeightAnchor = inputContainerView.heightAnchor.constraint(equalToConstant: 150)
		inputContainerHeightAnchor?.isActive = true
		
		//adding name placeholder in the form
		inputContainerView.addSubview(nameTextField)
		inputContainerView.addSubview(nameSeperatorView)
		inputContainerView.addSubview(emailTextField)
		inputContainerView.addSubview(emailSeperatorView)
		inputContainerView.addSubview(passwordTextField)
		
		nameTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
		nameTextField.topAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: 0).isActive = true
		nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
		nameTextFieldHeightAnchor?.isActive = true
		nameTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
		
		
		nameSeperatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
		nameSeperatorView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
		nameSeperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
		nameSeperatorView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
		
		emailTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
		emailTextField.topAnchor.constraint(equalTo: nameSeperatorView.topAnchor, constant: 0).isActive = true
		emailTextFieldHeightAnchor =  emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
		emailTextFieldHeightAnchor?.isActive = true
		emailTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
		
		emailSeperatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
		emailSeperatorView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
		emailSeperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
		emailSeperatorView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
		
		passwordTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
		passwordTextField.topAnchor.constraint(equalTo: emailSeperatorView.topAnchor, constant: 0).isActive = true
		
		passwordTextFieldHeightAnchor =  passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
		passwordTextFieldHeightAnchor?.isActive = true
		passwordTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
		
		setupLoginButton()
		setupLoginRegisterSegmentedControl()
	}
	
	func setupLoginButton(){
		loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		loginButton.topAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant:	12).isActive = true
		loginButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40).isActive = true
		loginButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
	}
	func setupLoginRegisterSegmentedControl (){
		loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor,constant:-12).isActive = true
		loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 25).isActive = true
		loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
	}
	override var preferredStatusBarStyle: UIStatusBarStyle{
		return .lightContent
	}
}
