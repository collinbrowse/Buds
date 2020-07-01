//
//  WelcomeVC.swift
//  Buds
//
//  Created by Collin Browse on 6/15/20.
//  Copyright © 2020 Collin Browse. All rights reserved.
//

import UIKit

class WelcomeVC: BudsDataLoadingVC {
    
    let backgroundImageView = UIImageView(image: Images.fullscreenBackgroundImage)
    let logInButton = UIButton()
    let registerButton = UIButton()
    let logInBackgroundView = UIView()
    let logInColor = UIColor(red: 0.2, green: 0.42, blue: 0.47, alpha: 1.0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBackgroundImageView()
        configureLogInButton()
        configureRegisterButton()
        configureLogInBackgroundView()
        layoutUI()
        title = "Buds"
    }
    
    
    @objc func pushRegisterVC() {
        let destVC = RegisterVC()
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    
    @objc func pushLogInVC() {
        let destVC = LogInVC()
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    
    private func configureBackgroundImageView() {
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    private func configureLogInButton() {
        logInButton.translatesAutoresizingMaskIntoConstraints = false
        logInButton.backgroundColor = logInColor
        logInButton.setTitleColor(.white, for: .normal)
        logInButton.setTitle("Log In", for: .normal)
        logInButton.reversesTitleShadowWhenHighlighted = true
        logInButton.addTarget(self, action: #selector(pushLogInVC), for: .touchUpInside )
    }
    
    
    private func configureRegisterButton() {
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.backgroundColor = UIColor(red: 0.25, green: 0.65, blue: 0.55, alpha: 1.0)
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.setTitle("Register", for: .normal)
        registerButton.reversesTitleShadowWhenHighlighted = true
        registerButton.addTarget(self, action: #selector(pushRegisterVC), for: .touchUpInside)
    }
    
    
    private func configureLogInBackgroundView() {
        logInBackgroundView.backgroundColor = logInColor
        logInBackgroundView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    private func layoutUI() {
        
        view.addSubviews(backgroundImageView, logInButton, registerButton, logInBackgroundView)
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            logInButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            logInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            logInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            logInButton.heightAnchor.constraint(equalToConstant: 45),
            
            registerButton.bottomAnchor.constraint(equalTo: logInButton.topAnchor),
            registerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            registerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            registerButton.heightAnchor.constraint(equalToConstant: 45),
            
            logInBackgroundView.topAnchor.constraint(equalTo: logInButton.bottomAnchor),
            logInBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            logInBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            logInBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
