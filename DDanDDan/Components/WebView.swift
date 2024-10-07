//
//  WebView.swift
//  DDanDDan
//
//  Created by paytalab on 10/7/24.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    public let url: String
    
    func makeUIView(context: Context) -> WKWebView {
        
        guard let url = URL(string: url) else {
            return WKWebView()
        }
        let webView = WKWebView()
        webView.load(URLRequest(url: url))
        return webView
    }
    func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<WebView>) {
        
    }
    
}

#Preview {
    WebView(url: "https://www.naver.com")
}
