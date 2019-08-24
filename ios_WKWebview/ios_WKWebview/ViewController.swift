//
//  ViewController.swift
//  ios_WKWebview
//
//  Created by darren on 2019/8/23.
//  Copyright © 2019 haiding.123.com. All rights reserved.
//

import UIKit
import WebKit
import WebViewJavascriptBridge

class ViewController: UIViewController {
    lazy var btn: UIButton = {
        let btn = UIButton.init(frame: CGRect.init(x: 20, y: UIScreen.main.bounds.height - 120, width: UIScreen.main.bounds.width - 40, height: 40))
        btn.setTitle("原生的按钮，点击触发js的alert", for: UIControl.State.normal)
        btn.backgroundColor = UIColor.blue
        btn.layer.cornerRadius = 20
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(clickBtn), for: UIControl.Event.touchUpInside)
        return btn
    }()

    lazy var webView: WKWebView = {
        let config = WKWebViewConfiguration()
        config.processPool = WKProcessPool()
        let preferences = WKPreferences.init()
        preferences.javaScriptCanOpenWindowsAutomatically = true
        config.preferences = preferences
        let web = WKWebView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), configuration: config)
        web.navigationDelegate = self
        return web
    }()
    var bridge: WKWebViewJavascriptBridge!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        initWebNotic()
    }
    
    func initView() {
        self.view.backgroundColor = UIColor.groupTableViewBackground
        self.view.addSubview(self.webView)
        self.webView.scrollView.contentInsetAdjustmentBehavior = .never
        
        let path = Bundle.main.path(forResource: "index", ofType:"html", inDirectory:"dist") ?? ""
        let url = URL.init(fileURLWithPath: path)
        let request = URLRequest.init(url: url)
        self.webView.load(request)
        
        self.view.addSubview(self.btn)
        
        // 开启日志
        // WKWebViewJavascriptBridge.enableLogging()
        // 给webView建立JS和OC的沟通桥梁
        self.bridge = WKWebViewJavascriptBridge(for: self.webView)
        self.bridge.setWebViewDelegate(self)
    }

    @objc func clickBtn() {
        self.bridge.callHandler("showAlert", data: "呵呵呵呵") { (responseData) in
            print(responseData ?? "")
            if ((responseData as? String ?? "") == "让ios自己弹框") {
                let alertController = UIAlertController(title: "系统提示", message: "ios弹框", preferredStyle: UIAlertController.Style.alert)
                let cancelAction = UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: nil )
                let okAction = UIAlertAction(title: "确定", style: UIAlertAction.Style.default) { (ACTION) in
                    print("确定")
                }
                alertController.addAction(cancelAction);
                alertController.addAction(okAction);
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func initWebNotic() {
        // js调用ios方法，同时可传递参数给js
        self.bridge.registerHandler("getPhoneInfo") { (data, responseCallback) in
            let devicename = UIDevice.current.name
            let systemName = UIDevice.current.systemName
            let systemVersion = UIDevice.current.systemVersion
            let str = "设备名称：\(devicename), 系统名称：\(systemName), 系统版本\(systemVersion)"
            responseCallback!(str)
        }
        
        self.bridge.registerHandler("getJson") { (data, responseCallback) in
            var dict = [String:String]()
            dict["id"] = "测试id"
            dict["baseUrl"] = "http://baidu.com"
            print(dict)
            let data = try? JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
            let strJson = String.init(data: data!, encoding: String.Encoding.utf8) ?? ""
            responseCallback!(strJson)
        }
    }

}
extension ViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("didFinish")
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("didStartProvisionalNavigation")
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("withError")
    }
}


