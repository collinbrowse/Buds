//
//  WelcomeViewController.swift
//  Buds
//
//  Created by Collin Browse on 6/25/19.
//  Copyright © 2019 Collin Browse. All rights reserved.
//

import Foundation
import UIKit
import OnboardKit


class WelcomeViewController: UIViewController {
    
    var modelController: ModelController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .label
        presentOnboarding()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
     
        // If somehow the model controller isn't passed through from the App Delegate, create it here. 
        if modelController == nil {
            modelController = ModelController()
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? RegisterViewController {
            vc.modelController = modelController
        } else if let vc = segue.destination as? LogInViewController {
            vc.modelController = modelController
        }
    }
    
    
    private func presentOnboarding() {
        
        PersistenceManager.shared.setLaunchStatus(status: false)
        
        if !PersistenceManager.shared.appHasLaunchedBefore {
            
            // Testing the onboarding screens
            let pageOne = OnboardPage(title: "Welcome to Buds",
                                      imageName: "activity_feed_mockup",
                                      description: "Buds helps you track your cannabis use so you know what works for you")
            let pageTwo = OnboardPage(title: "Register for an account",
                                      imageName: "favorites_mockup",
                                      description: "Buds keeps your data synced to any device you sign into. \n\nIf privacy is a concern for you, enter an alias. \nYou must be 21+ to use Buds.")
            let pageThree = OnboardPage(title: "Search for a strain",
                                        imageName: "new_activity_mockup",
                                        description: "Then enter the details of your activity. \n\nThen your activity shows in your Feed and Favorites!",
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
    
}
