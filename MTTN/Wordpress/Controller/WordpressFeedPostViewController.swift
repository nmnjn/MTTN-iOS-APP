//
//  WordpressFeedPostViewController.swift
//  MTTN
//
//  Created by Naman Jain on 12/05/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit
import WebKit

class WordpressFeedPostViewController: UIViewController, WKUIDelegate {
   
    weak var post : postDetails?
    var webView: WKWebView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        if #available(iOS 13.0, *) {
            
        } else {
            setupTheming()
        }
        addWebContent()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if #available(iOS 12.0, *) {
            let userInterfaceStyle = traitCollection.userInterfaceStyle
            if userInterfaceStyle == .light{
                webView.isOpaque = true
            }else{
                webView.isOpaque = false
            }
        } else {
            // Fallback on earlier versions
        } // Either .unspecified, .light, or .dark
        // Update your user interface based on the appearance
    }
    
    private func addWebContent() {
        let HeaderString = "<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>"
        if let content = post?.renderedContent {
            let webContent : String = content
            let mainbundle = Bundle.main.bundlePath
            let bundleURL = URL(fileURLWithPath: mainbundle)
            if #available(iOS 13.0, *) {
                if self.traitCollection.userInterfaceStyle == .dark {
                    webView.backgroundColor = .black
                    webView.isOpaque = false
//                    webView.scrollView.backgroundColor = .black
//                    view.backgroundColor = .black
                }
                webView.loadHTMLString(HeaderString + iOS13AdaptiveCSSString + webContent, baseURL: bundleURL)
            } else {
                if UserDefaults.standard.darkModeEnabled {
                    webView.loadHTMLString(HeaderString + CSSStringDark + webContent, baseURL: bundleURL)
                }else{
                    webView.loadHTMLString(HeaderString + CSSStringLight + webContent, baseURL: bundleURL)
                }
            }
        }
    }
}

extension WordpressFeedPostViewController: Themed{
    func applyTheme(_ theme: AppTheme) {
        webView.backgroundColor = theme.backgroundColor
        webView.scrollView.backgroundColor = theme.backgroundColor
        webView.isOpaque = false
    }
}
