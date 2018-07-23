//
//  SingleWebViewController.swift
//  Kinds
//
//  Created by yuanfang on 2018/6/22.
//  Copyright © 2018年 yuanfang. All rights reserved.
//

import UIKit
import WebKit

class SingleWebViewController: BaseViewController, WKScriptMessageHandler {

    var webView: WKWebView!
    var progBar: UIProgressView!
    var url: String? = nil
    var prama: Dictionary<String, Any>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createViews()
        removeCacheData()
    }
    
    override func goBack() {
        if webView.canGoBack {
            webView.goBack()
        } else {
            super.goBack()
        }
    }
    
    //移除代理和观察者
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    func loadUrl() {
        if (url == nil) {
            return
        }
        
        if ((prama?.keys) != nil) {
            var mstr: String = String("")
            
            if !(url?.contains("?"))! {
                mstr.append("?")
            }
            for(key, value)in prama! {
                mstr.append("\(key)=\(value)&")
            }
            if (mstr.count > 0) {
                let last = mstr.substring(from: mstr.count - 1)
                if (last.contains("&")) {
                    mstr = String(mstr.dropLast())
//                    let indexs = mstr.index(mstr.startIndex, offsetBy: 0)
//                    let indexe = mstr.index(mstr.startIndex, offsetBy: mstr.count - 1)
//                    mstr = String(mstr[indexs..<indexe])
                    
//                    mstr = mstr.substring(from: mstr.count - 1)
//                    mstr = mstr.String(prefix(mstr.count - 1))
//                    mstr = mstr.substring(from: mstr.index(mstr.startIndex, offsetBy: mstr.count - 1))
                    
                    
//                    let finalStr = testStr.substring(to: index) // Swift 3
//                    let finalStr = String(testStr[..<index]) // Swift 4
//
//                    let finalStr = testStr.substring(from: index) // Swift 3
//                    let finalStr = String(testStr[index...]) // Swift 4
//
//                    //Swift 3
//                    let finalStr = testStr.substring(from: index(startIndex, offsetBy: 3))
//
//                    //Swift 4
//                    let reqIndex = testStr.index(testStr.startIndex, offsetBy: 3)
//                    let finalStr = String(testStr[..<reqIndex])
                    
                }
            }
            if (mstr.count > 0) {
                url?.append(mstr)
            }
        }
        
        webView.load(NSURLRequest.init(url: URL.init(string: url!)!) as URLRequest)
        // 加载本地Html页面
//        let path = Bundle.main.path(forResource: "", ofType: ".html")
//        let url = NSURL.init(fileURLWithPath: path!)
    }
    
    func postUrl(urlString: String) {
        let url = NSURL(string: urlString)
        let requst = NSMutableURLRequest(url: url! as URL)
        requst.httpMethod = "POST"
        requst.httpBody = "username=aaa&password=123".data(using: String.Encoding.utf8)
        
        let session = URLSession.shared
        let task = session.dataTask(with: requst as URLRequest) { (data, response, error) in
            self.webView.loadHTMLString(String(data: data!, encoding: String.Encoding.utf8)!, baseURL: nil)
        }
        task.resume()
    }
    
    func createViews() {
        let rightBarItem = UIBarButtonItem(title: "心愿种子", style: .plain, target: self, action: #selector(wishSeed))
        navigationItem.rightBarButtonItem = rightBarItem
        
        //        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let config = WKWebViewConfiguration()
        let userContent = WKUserContentController()
        userContent.add(self, name: "NativeMethod")
        config.userContentController = userContent
        webView = WKWebView.init(frame: CGRect.zero, configuration: config)
        
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        loadUrl()
        
        //进度条
        progBar = UIProgressView()
        progBar.progress = 0.0
        progBar.alpha = 1.0
        progBar.tintColor = UIColor.red
        webView.addSubview(progBar)
        
        progBar.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(webView)
            make.height.equalTo(3)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            if progBar != nil {
                progBar.setProgress(Float(webView.estimatedProgress), animated: true)
                if(self.webView.estimatedProgress >= 1.0) {
                    UIView.animate(withDuration: 0.2, delay: 0.1, options: UIViewAnimationOptions.curveEaseInOut, animations: { () -> Void in
                        self.progBar.alpha = 0.0
                    }, completion: { (finished:Bool) -> Void in
                        self.progBar.progress = 0
                    })
                }
            }
        }
    }
    
    func removeCacheData() {
        //清理缓存
        if #available(iOS 9.0, *) {
            let types = NSSet.init(array: [WKWebsiteDataTypeDiskCache,WKWebsiteDataTypeMemoryCache])
            WKWebsiteDataStore.default().removeData(ofTypes: types as! Set<String>, modifiedSince: Date()) {
            }
        } else {
            let libraryPath = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first
            let cookiePath = libraryPath?.appending("/Cookies")
            do {
                try FileManager.default.removeItem(atPath: cookiePath!)
            } catch {
                // 删除失败
            }
        }
        //        if UIDevice.current.systemVersion.compare("9.0") ==  ComparisonResult.orderedAscending{
        //
        //        } else {
        //
        //        }
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        webView.configuration.userContentController.removeScriptMessageHandler(forName: "NativeMethod")
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SingleWebViewController: WKNavigationDelegate, WKUIDelegate, UIScrollViewDelegate {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        //"NativeMethod"需要与userContent.add(self, name: "NativeMethod")中相同
        if message.name == "NativeMethod" {
            if message.body as! String == "first" {
                //可根据body的值调用相应的方法
                debugPrint(message.body)
            }
        }
    }
    
    //MARK: - WKNavigationDelegate
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        //页面开始加载时调用
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        //当内容开始返回时调用
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // 页面加载完成之后调用
        self.navigationItem.title = self.webView.title
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        // 页面加载完成之后调用
    }
    
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        //// 接收到服务器跳转请求之后调用
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        let url = navigationAction.request.url
        
        let scheme = url?.scheme
        
        guard let schemeStr = scheme else { return
            
        }
        if schemeStr == "tel" {
            //iOS10 改为此函数
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url!, options: [String : Any](), completionHandler: nil)
            } else {
                // Fallback on earlier versions
            }
        }
        
        decisionHandler(.allow)
        // 在发送请求之前，决定是否跳转
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        decisionHandler(.allow)
        // 在收到响应后，决定是否跳转
    }
    
    //MARK: - WKUIDelegate
    // 创建一个新的WebView
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        return WKWebView()
    }
    
    // 输入框
    // JS端调用prompt函数时，会触发此方法
    // 要求输入一段文本
    // 在原生输入得到文本内容后，通过completionHandler回调给JS
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void){
        
    }
    
    // 确认框
    // JS端调用confirm函数时，会触发此方法
    // 通过message可以拿到JS端所传的数据
    // 在iOS端显示原生alert得到YES/NO后
    // 通过completionHandler回调给JS端
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void){
        
    }
    
    // 警告框
    // 在JS端调用alert函数时，会触发此代理方法。
    // JS端调用alert时所传的数据可以通过message拿到
    // 在原生得到结果后，需要回调JS，是通过completionHandler回调
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void){
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) -> Void in
            completionHandler()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    //swift调用js
    @objc func wishSeed() {
        self.webView.evaluateJavaScript("clear_cache('哈哈哈哈哈')", completionHandler: nil)
    }
    
}

//        userContent.add(MessageHandler.init(delegate: self as! WKScriptMessageHandler), name: "NativeMethod")
//        userContent.add(MessageHandler(delegate: self as! WKScriptMessageHandler), name: "NativeMethod")
//class MessageHandler: NSObject, WKScriptMessageHandler, UIGestureRecognizerDelegate {
//    init(delegate: WKScriptMessageHandler) {
//        self.delegate = delegate
//        super.init()
//    }
//
//    weak var delegate: WKScriptMessageHandler?
//
//    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
//        delegate?.userContentController(userContentController, didReceive: message)
//    }
//
//    deinit {
//        print("MessageHandler deallocated")
//    }
//}

