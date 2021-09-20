//
//  DetailViewController.swift
//  DetailViewController
//
//  Created by Manish Punia on 20/09/21.
//

import Foundation


import UIKit
import WebKit
class DetailViewController : UIViewController, WKUIDelegate {
    
    var webView: WKWebView!
    var url:URL!
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    
    convenience init(url:URL) {
        self.init()
        self.url = url
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let myRequest = URLRequest(url: url)
        webView.load(myRequest)
    }
    
}
