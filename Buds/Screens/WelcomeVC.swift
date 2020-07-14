//
//  WelcomeVC.swift
//  Buds
//
//  Created by Collin Browse on 6/15/20.
//  Copyright © 2020 Collin Browse. All rights reserved.
//

import UIKit
import OnboardKit

class WelcomeVC: BudsDataLoadingVC {
    
    let backgroundImageView = UIImageView(image: Images.fullscreenBackgroundImage)
    let logInButton = UIButton()
    let registerButton = UIButton()
    let logInBackgroundView = UIView()
    let logInColor = UIColor(red: 0.2, green: 0.42, blue: 0.47, alpha: 1.0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presentOnboarding()
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
    
    
    private func presentOnboarding() {
                
        if !PersistenceManager.shared.appHasLaunchedBefore {
            
            let pageOne = OnboardPage(title: "Welcome to Buds",
                                      imageName: "activity_feed_mockup",
                                      description: "Buds helps you track your cannabis use so you know what works for you")
            let pageTwo = OnboardPage(title: "Register for an account",
                                      imageName: "favorites_mockup",
                                      description: "Buds keeps your data synced to any device you sign into. \n\nIf privacy is a concern for you, enter an alias. \nYou must be 21+ to use Buds.")
            let pageThree = OnboardPage(title: "Search for a strain",
                                        imageName: "new_activity_mockup",
                                        description: "Then enter the details of your activity. \n\nTap + and your activity will show in your Feed and Favorites!",
                                        advanceButtonTitle: "Done"
            )
            
            let appearance = OnboardViewController.AppearanceConfiguration(tintColor: .systemGreen,
                                                                           titleColor: .label,
                                                                           textColor: .label,
                                                                           backgroundColor: .systemBackground,
                                                                           imageContentMode: .scaleAspectFill,
                                                                           titleFont: UIFont.boldSystemFont(ofSize: 26.0),
                                                                           textFont: UIFont.boldSystemFont(ofSize: 17.0),
                                                                           advanceButtonStyling: .none,
                                                                           actionButtonStyling: .none)
            
            let pages = [pageOne, pageTwo, pageThree]
            let onboardingViewController = OnboardViewController(pageItems: pages, appearanceConfiguration: appearance)
            
            onboardingViewController.presentFrom(self, animated: true)
            
            PersistenceManager.shared.didLaunch()
        }
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
