//
//  ViewController.swift
//  ios_UIWebview
//
//  Created by darren on 2019/8/23.
//  Copyright © 2019 haiding.123.com. All rights reserved.
//

import UIKit
import JavaScriptCore

@objc protocol JavaScriptMethodProtocol: JSExport {
    func getPhoneInfo() -> String
    func getJson() -> String
}

class MyJavaScriptMethod : NSObject, JavaScriptMethodProtocol {
    
    private weak var holderController: UIViewController?
    
    init(holderController: UIViewController) {
        super.init()
        self.holderController = holderController
    }
    
    func getPhoneInfo() -> String {
        if self.holderController == nil {
            return ""
        }
        return (self.holderController as! ViewController).getPhoneInfo()
    }
    
    func getJson() -> String {
        if self.holderController == nil {
            return ""
        }
        return (self.holderController as! ViewController).getJson()
    }
}


class ViewController: UIViewController {
    
    lazy var webView: UIWebView = {
        let web = UIWebView.init(frame: self.view.bounds)
        return web
    }()
    var jsContext: JSContext?
    
    lazy var btn: UIButton = {
        let btn = UIButton.init(frame: CGRect.init(x: 20, y: UIScreen.main.bounds.height - 120, width: UIScreen.main.bounds.width - 40, height: 40))
        btn.setTitle("原生的按钮，点击触发js的alert", for: UIControl.State.normal)
        btn.backgroundColor = UIColor.blue
        btn.layer.cornerRadius = 20
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(clickBtn), for: UIControl.Event.touchUpInside)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadWebView()
        self.view.addSubview(self.btn)
    }

    func loadWebView() {
        self.view.addSubview(self.webView)
        
        let path = Bundle.main.path(forResource: "index", ofType:"html", inDirectory:"dist") ?? ""
        let url = URL.init(fileURLWithPath: path)
        
        self.jsContext = self.webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as? JSContext
        self.jsContext?.setObject(MyJavaScriptMethod(holderController:self), forKeyedSubscript: "phone" as NSCopying & NSObjectProtocol)
        
        let request = URLRequest.init(url: url)
        self.webView.loadRequest(request)
    }
    /// 返回设备信息给js显示
    func getPhoneInfo() -> String {
        let devicename = UIDevice.current.name
        let systemName = UIDevice.current.systemName
        let systemVersion = UIDevice.current.systemVersion
        
        return "设备名称：\(devicename), 系统名称：\(systemName), 系统版本\(systemVersion)"
    }
    func getJson() -> String {
        var dict = [String:String]()
        dict["id"] = "测试id"
        dict["baseUrl"] = "http://baidu.com"
        print(dict)
        let data = try? JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
        let strJson = String.init(data: data!, encoding: String.Encoding.utf8) ?? ""
        return strJson
    }
    
    @objc func clickBtn() {
        let jSStr = "showAlert('呵呵呵呵')"
        _ = self.jsContext?.evaluateScript(jSStr)
//        self.webView.stringByEvaluatingJavaScript(from: jSStr)
    }
}




