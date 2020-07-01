//
//  LogInVC.swift
//  Buds
//
//  Created by Collin Browse on 6/16/20.
//  Copyright © 2020 Collin Browse. All rights reserved.
//

import UIKit
import SVProgressHUD

class LogInVC : BudsDataLoadingVC {
    
    let backgroundImageView = UIImageView(image: Images.fullscreenBackgroundImage)
    let emailTextField = BudsTextField(placeholderText: "Email")
    let passwordTextField = BudsTextField(placeholderText: "Password")
    let logInButton = BudsButton(backgroundColor: UIColor(red: 0.2, green: 0.42, blue: 0.47, alpha: 1.0), title: "Log In")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBackgroundImageView()
        configureEmailTextField()
        configurePasswordTextField()
        configureLogInButton()
        configureUIDelegates()
        layoutUI()
        title = "Log In"
    }
    
    
    @objc func logInUser() {
        SVProgressHUD.show()
        
        let email = emailTextField.text
        var password = passwordTextField.text
        
        if (!password!.isEmpty && !email!.isEmpty) {
            
            Network.logInUser(email: email!, password: password!) { (result) in
                SVProgressHUD.dismiss()
                
                switch result {
                case .success(let person):
                    self.showTabBarController(person: person)
                case .failure(let error):
                    self.presentBudsAlertOnMainThread(title: "Unable to Log In", message: error.localizedDescription, buttonTitle: "OK")
                    return
                }
            }

        }
        else {
            SVProgressHUD.dismiss()
            presentBudsAlertOnMainThread(title: "Unable To Log In", message: "All fields must be filled out", buttonTitle: "OK")
        }
        passwordTextField.text = nil
        password = nil
    }
    
    
    private func configureBackgroundImageView() {
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        //backgroundImageView.contentMode = .scaleToFill
    }
    
    
    private func configureEmailTextField() {
        emailTextField.textContentType = .emailAddress
        emailTextField.keyboardType = .emailAddress
    }
    

    private func configurePasswordTextField() {
        passwordTextField.returnKeyType = .go
        passwordTextField.textContentType = .password
        passwordTextField.isSecureTextEntry = true
    }


    private func configureLogInButton() {
        logInButton.reversesTitleShadowWhenHighlighted = true
        logInButton.addTarget(self, action: #selector(logInUser), for: .touchUpInside)
    }
    
    
    private func configureUIDelegates() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    
    private func layoutUI() {
        
        view.addSubviews(backgroundImageView, emailTextField, passwordTextField, logInButton)
        
        let padding : CGFloat = 12
        let height : CGFloat = 44
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emailTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding * 2),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            emailTextField.heightAnchor.constraint(equalToConstant: height),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: padding),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            passwordTextField.heightAnchor.constraint(equalToConstant: height),
            
            logInButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: padding * 2),
            logInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            logInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            logInButton.heightAnchor.constraint(equalToConstant: height)
        ])
    }
}


extension LogInVC : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            textField.resignFirstResponder()
            logInUser()
        }
        return true
    }
    
}
