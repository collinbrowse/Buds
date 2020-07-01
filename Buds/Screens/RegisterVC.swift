//
//  RegisterVC.swift
//  Buds
//
//  Created by Collin Browse on 6/16/20.
//  Copyright © 2020 Collin Browse. All rights reserved.
//

import UIKit
import SVProgressHUD

class RegisterVC : BudsDataLoadingVC {
    
    let backgroundImageView = UIImageView(image: Images.fullscreenBackgroundImage)
    let nameTextField = BudsTextField(placeholderText: "Name")
    let birthdayTextField = BudsTextField(placeholderText: "Birthday")
    let emailTextField = BudsTextField(placeholderText: "Email")
    let passwordTextField = BudsTextField(placeholderText: "Password")
    let registerButton = BudsButton(backgroundColor: UIColor(red: 0.2, green: 0.42, blue: 0.47, alpha: 1.0), title: "Register")
    let legalInfoTextView = UITextView()
    let datePicker = UIDatePicker()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBackgroundImageView()
        configureDatePicker()
        configureEmailTextField()
        configurePasswordTextField()
        configureLegalInfoTextView()
        configureRegisterButton()
        configureUIDelegates()
        layoutUI()
        title = "Register"
    }
    
    
    @objc func registerUser() {
        SVProgressHUD.show()
        
        let email = emailTextField.text
        var password = passwordTextField.text
        let name = nameTextField.text
        let birthday = birthdayTextField.text
        
        
        if (!email!.isEmpty && !password!.isEmpty && !name!.isEmpty && !birthday!.isEmpty && isValidEmail(emailID: email!)) {
            
            Network.registerUser(name: name!, birthday: birthday!, email: email!, password: password!) { (result) in
                SVProgressHUD.dismiss()

                switch result {
                case .success(let person):
                    self.showTabBarController(person: person)
                case .failure(let error):
                    self.presentBudsAlertOnMainThread(title: "Unable To Register", message: error.localizedDescription, buttonTitle: "OK")
                }
            }
        }
        else {
            SVProgressHUD.dismiss()
            presentBudsAlertOnMainThread(title: "Unable To Register", message: "All fields must be filled out & email must be valid", buttonTitle: "OK")
        }
        passwordTextField.text = nil
        password = nil
    }
    
    
    /// Action performed when the user touches away from the data picker
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        birthdayTextField.text = dateFormatter.string(from: datePicker.date)
    }
    

    private func isValidEmail(emailID:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailID)
    }
    
    
    private func configureBackgroundImageView() {
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        //backgroundImageView.contentMode = .scaleAspectFill
    }
    
    
    private func configureEmailTextField() {
        emailTextField.textContentType = .emailAddress
        emailTextField.keyboardType = .emailAddress
    }
    
    
    private func configurePasswordTextField() {
        passwordTextField.returnKeyType = .go
        passwordTextField.textContentType = .newPassword
        passwordTextField.isSecureTextEntry = true
    }
    
    
    private func configureLegalInfoTextView() {
        
        let attributedString = LegalInfo.attributedString
        let privacyURL = LegalInfo.privacyPolicyURL
        let icons8URL = LegalInfo.icons8URL

        attributedString.setAttributes([.link: privacyURL], range: NSMakeRange(33, 14))
        attributedString.setAttributes([.link: icons8URL], range: NSMakeRange(58, 6))

        legalInfoTextView.translatesAutoresizingMaskIntoConstraints = false
        legalInfoTextView.attributedText = attributedString
        legalInfoTextView.isUserInteractionEnabled = true
        legalInfoTextView.backgroundColor = .clear
        legalInfoTextView.isEditable = false
        legalInfoTextView.textAlignment = .center
        legalInfoTextView.textColor = .white
        legalInfoTextView.sizeToFit()
        legalInfoTextView.font = UIFont.systemFont(ofSize: 14)
        legalInfoTextView.linkTextAttributes = [
            .foregroundColor: UIColor.white,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
    }
    
    
    private func configureRegisterButton() {
        registerButton.reversesTitleShadowWhenHighlighted = true
        registerButton.addTarget(self, action: #selector(registerUser), for: .touchUpInside)
    }
    
    
    private func configureUIDelegates() {
        nameTextField.delegate = self
        birthdayTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    
    private func configureDatePicker() {

        let ofAgeDate = Calendar.current.date(byAdding: .year, value: -21, to: Date())
        datePicker.datePickerMode = .date
        datePicker.maximumDate = ofAgeDate
        datePicker.addTarget(self, action: #selector(RegisterVC.dateChanged(datePicker:)), for: .valueChanged)

        // Close the date picker if the user touches away
        let datePickerTapGesture = UITapGestureRecognizer(target: self, action: #selector(RegisterVC.viewTapped(gestureRecognizer: )))
        view.addGestureRecognizer(datePickerTapGesture)
        birthdayTextField.inputView = datePicker
    }


    
    
    private func layoutUI() {
        
        view.addSubviews(backgroundImageView, nameTextField, birthdayTextField, emailTextField, passwordTextField, legalInfoTextView, registerButton)
        
        let padding : CGFloat = 12
        let height : CGFloat = 44
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding * 2),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            nameTextField.heightAnchor.constraint(equalToConstant: height),
           
            birthdayTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: padding),
            birthdayTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            birthdayTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            birthdayTextField.heightAnchor.constraint(equalToConstant: height),
            
            emailTextField.topAnchor.constraint(equalTo: birthdayTextField.bottomAnchor, constant: padding),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            emailTextField.heightAnchor.constraint(equalToConstant: height),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: padding),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            passwordTextField.heightAnchor.constraint(equalToConstant: height),
            
            legalInfoTextView.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: padding),
            legalInfoTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            legalInfoTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            legalInfoTextView.heightAnchor.constraint(equalToConstant: height),
            
            registerButton.topAnchor.constraint(equalTo: legalInfoTextView.bottomAnchor, constant: padding),
            registerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            registerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            registerButton.heightAnchor.constraint(equalToConstant: height)
        ])
    }
}


extension RegisterVC : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == nameTextField {
            birthdayTextField.becomeFirstResponder()
        } else if textField == birthdayTextField {
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            textField.resignFirstResponder()
            registerUser()
        }
        return true
    }
}
