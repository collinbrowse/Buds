//
//  StrainDetailsWebKitController.swift
//  Buds
//
//  Created by Collin Browse on 9/2/19.
//  Copyright © 2019 Collin Browse. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD
import Alamofire

class StrainDetailsWebKitController: UIViewController, WKNavigationDelegate {
    
    private var strainApiUrl = "strainapi.evanbusse.com/3HT8al6/strains/search/"
    private var detail = ""
    private var strainDetail = ""
    
    @IBOutlet weak var effect: UILabel!
    @IBOutlet weak var race: UILabel!
    @IBOutlet weak var flavor: UILabel!
    
    override func loadView() {
       
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show()
        let testUrl = URL(string: "https://strainapi.evanbusse.com/3HT8al6/strains/search/name/elephant")
        
        Alamofire.request(testUrl!, method: .get).validate().responseJSON { (response) in
            if response.result.isSuccess {
                print(response.result)
                self.effect.text = "response"
                self.race.text = "response"
                self.flavor.text = "response"
                
            }
        }
        //webView.load(request)
    }
    
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        SVProgressHUD.dismiss()
    }
    
    
    
    
}
