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
    }
    
    override func viewWillAppear(_ animated: Bool) {
     
        // If somehow the model controller isn't passed through from the App Delegate, create it here. 
        if modelController == nil {
            modelController = ModelController()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func myUnwindAction(segue: UIStoryboardSegue) {}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? RegisterViewController {
            vc.modelController = modelController
        } else if let vc = segue.destination as? LogInViewController {
            vc.modelController = modelController
        }
    }
    
    
    
    @IBAction func onBoardUser(_ sender: Any) {
        
        // Testing the onboarding screens
        let pageOne = OnboardPage(title: "Welcome to OnboardKit",
                               imageName: "weed_background-2",
                               description: "OnboardKit helps you add onboarding to your iOS app")
        let pageTwo = OnboardPage(title: "Welcome to OnboardKit",
                                imageName: "weed_background-2",
                                description: "OnboardKit helps you add onboarding to your iOS app")
        let pageThree = OnboardPage(title: "Welcome to OnboardKit",
                                imageName: "weed_background-2",
                                description: "OnboardKit helps you add onboarding to your iOS app")
        
        let appearance = OnboardViewController.AppearanceConfiguration(tintColor: .orange,
        titleColor: .red,
        textColor: .white,
        backgroundColor: .black,
        imageContentMode: .scaleAspectFit,
        titleFont: UIFont.boldSystemFont(ofSize: 32.0),
        textFont: UIFont.boldSystemFont(ofSize: 17.0),
        advanceButtonStyling: .none,
        actionButtonStyling: .none)
        
        let pages = [pageOne, pageTwo, pageThree]
        let onboardingViewController = OnboardViewController(pageItems: pages, appearanceConfiguration: appearance)
        
        onboardingViewController.presentFrom(self, animated: true)
    }
    
    
}
