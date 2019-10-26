//
//  WelcomeViewController.swift
//  Buds
//
//  Created by Collin Browse on 6/25/19.
//  Copyright © 2019 Collin Browse. All rights reserved.
//

import Foundation
import UIKit



class WelcomeViewController: UIViewController {
    
    var modelController: ModelController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
}
