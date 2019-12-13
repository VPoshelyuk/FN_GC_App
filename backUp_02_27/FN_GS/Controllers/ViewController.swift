//
//  ViewController.swift
//  FN_GS
//
//  Created by Viacheslav Poshelyk on 2/22/19.
//  Copyright © 2019 Viachaslau Pashaliuk. All rights reserved.
//

import UIKit
import Firebase
import CoreData

class ViewController: UIViewController {
    
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
    
    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.white
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(UIColor.init(red: 144/255, green: 210/255, blue: 232/255, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(handleLogIn), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        return button
    }()
    
    @objc func handleLogIn() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("Form is not valid")
            return
        }
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user: User?, error) in
            if error != nil {
                print(error!)
                let alert = UIAlertController(title: "Error!", message: "User with this log in/password combination doesn't exist", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){
                    (action) in print("Cancelled!")
                }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
                return
            }
            self.dismiss(animated: true, completion: nil)
            
        })
    }
    
    lazy var signupButton: UIButton = {
        let button = UIButton()
        button.setTitle("Not yet registered? Sign Up", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func handleSignUp() {
        let signUpController = SignUpController()
        present(signUpController, animated: true, completion: nil)
    }
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "E-Mail Address"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    let separationLine: UIView = {
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
    
    lazy var animationView: UIView = {
        let AView = UIView()
        AView.frame.size = self.view.frame.size
        AView.center = self.view.center
        
        let gradient = CAGradientLayer(layer: AView.layer)
        gradient.colors = [UIColor.init(red: 144/255, green: 210/255, blue: 232/255, alpha: 1).cgColor, UIColor.init(red: 220/255, green: 220/255, blue: 220/255, alpha: 1).cgColor]
        gradient.locations = [0, 1]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        gradient.frame = AView.bounds
        AView.layer.insertSublayer(gradient, at: 0)
        AView.translatesAutoresizingMaskIntoConstraints = false
        return AView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //view.backgroundColor = UIColor.init(red: 144/255, green: 210/255, blue: 232/255, alpha: 1)
        view.addSubview(animationView)
    
        view.addSubview(inputsContainerView)
        view.addSubview(loginButton)
        view.addSubview(signupButton)
        view.addSubview(logoImageView)
        self.hideKeyboardWhenTappedAround()
        
        setupInputsContainerView()
        setupLogInButton()
        setupSignUpButton()
        setupLogoIV()
        
        
    }
    
   override var prefersStatusBarHidden: Bool{
        return true
   }
    
    func setupLogoIV() {
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageView.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -56).isActive = true
        logoImageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    func setupInputsContainerView() {
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(separationLine)
        inputsContainerView.addSubview(passwordTextField)
        setupEMailTF()
        setupLine()
        setupPasswordTF()
    }
    
    func setupEMailTF(){
        emailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/2).isActive = true
    }

    func setupLine(){
        separationLine.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        separationLine.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        separationLine.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        separationLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    func setupPasswordTF(){
        passwordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/2).isActive = true
    }
    
    func setupLogInButton() {
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12).isActive = true
        loginButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    func setupSignUpButton() {
        signupButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signupButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 12).isActive = true
        signupButton.widthAnchor.constraint(equalToConstant: 250).isActive = true
        signupButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }


}


