//
//  SignUpController.swift
//  FN_GS
//
//  Created by Viacheslav Poshelyk on 2/23/19.
//  Copyright © 2019 Viachaslau Pashaliuk. All rights reserved.
//

import UIKit
import Firebase
import CoreData

class SignUpController: UIViewController {
    
    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "loginScreenLogo")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        return view
    }()
    
    lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.white
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(UIColor.init(red: 144/255, green: 210/255, blue: 232/255, alpha: 1), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    @objc func handleSignUp() {
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text, let key = keyTextField.text else {
            print("Form is not valid")
            return
        }
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user: User?, error) in
            if error != nil {
                print(error!)
                return
            }
            guard let uid = user?.uid else {
                return
            }
            //authenicated successfully
            let ref = Database.database().reference(fromURL: "https://fn-gs-c77c2.firebaseio.com/")
            let userRef = ref.child("users").child(uid)
            let values = ["name": name,"email": email, "key": key]
            userRef.updateChildValues(values, withCompletionBlock: { (err, ref) in
                if err != nil {
                    print(err!)
                    return
                }
                print("Saved successfully!")
                self.dismiss(animated: true, completion: nil)
            })
        
        })
    }
    
    lazy var backToLogInButton: UIButton = {
        let button = UIButton()
        button.setTitle("Back", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(self, action: #selector(backToLogIn), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func backToLogIn() {
        let viewController = ViewController()
        present(viewController, animated: false, completion: nil)
    }
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "First and Last Name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let separationLineName: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "E-Mail Address"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let separationLineEMail: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let separationLinePassword: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let keyTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "License Key"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var animationView: UIView = {
        let AView = UIView()
        AView.frame.size = view.frame.size
        AView.center = view.center

        let gradient = CAGradientLayer(layer: AView.layer)
        gradient.colors = [UIColor.init(red: 144/255, green: 210/255, blue: 232/255, alpha: 1).cgColor, UIColor.init(red: 220/255, green: 220/255, blue: 220/255, alpha: 1).cgColor]
        gradient.locations = [0, 1]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        gradient.frame = AView.bounds
        AView.layer.insertSublayer(gradient, at: 0)
        return AView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(animationView)
        view.addSubview(inputsContainerView)
        view.addSubview(signUpButton)
        view.addSubview(backToLogInButton)
        view.addSubview(logoImageView)
        self.hideKeyboardWhenTappedAround()
        
        setupInputsContainerView()
        setupsignUpButton()
        setupBackToLogInButton()
        setupLogoIV()
        
    }
    
    override var prefersStatusBarHidden: Bool{
         return true
    }
    
    
    func setupLogoIV() {
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageView.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -76).isActive = true
        logoImageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    func setupInputsContainerView() {
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        inputsContainerView.addSubview(nameTextField)
        inputsContainerView.addSubview(separationLineName)
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(separationLineEMail)
        inputsContainerView.addSubview(passwordTextField)
        inputsContainerView.addSubview(separationLinePassword)
        inputsContainerView.addSubview(keyTextField)
        
        setupNameTF()
        setupLineName()
        setupEMailTF()
        setupLine()
        setupPasswordTF()
        setupLinePassword()
        setupKeyTF()
    }
    
    func setupNameTF(){
        nameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/4).isActive = true
    }
    
    func setupLineName(){
        separationLineName.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        separationLineName.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        separationLineName.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        separationLineName.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    func setupEMailTF(){
        emailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/4).isActive = true
    }
    
    func setupLine(){
        separationLineEMail.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        separationLineEMail.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        separationLineEMail.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        separationLineEMail.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    func setupPasswordTF(){
        passwordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/4).isActive = true
    }
    
    func setupLinePassword(){
        separationLinePassword.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        separationLinePassword.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor).isActive = true
        separationLinePassword.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        separationLinePassword.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    func setupKeyTF(){
        keyTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        keyTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor).isActive = true
        keyTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        keyTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/4).isActive = true
    }
    
    func setupsignUpButton() {
        signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signUpButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12).isActive = true
        signUpButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        signUpButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    func setupBackToLogInButton(){
        backToLogInButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 6).isActive = true
        backToLogInButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 6).isActive = true
        backToLogInButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        backToLogInButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// add "back" button!!!
