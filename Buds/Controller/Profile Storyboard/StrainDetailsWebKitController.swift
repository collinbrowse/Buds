//
//  StrainDetailsWebKitController.swift
//  Buds
//
//  Created by Collin Browse on 9/2/19.
//  Copyright © 2019 Collin Browse. All rights reserved.
//

import UIKit
import WebKit

class StrainDetailsWebKitController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet var webView: WKWebView!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "https://www.google.com")
        let request = URLRequest(url: url!)
        
        webView.load(request)
    }
    
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("webkit finished")
    }
    
    
    
    
}
