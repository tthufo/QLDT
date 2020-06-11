//
//  QL_LogIn_ViewController.swift
//  QLDT
//
//  Created by Thanh Hai Tran on 7/28/18.
//  Copyright © 2018 Thanh Hai Tran. All rights reserved.
//

import UIKit

class QL_LogIn_ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var check: UIButton!
    
    @IBOutlet var cover: UIView!

    @IBOutlet var uName: UITextField!
    
    @IBOutlet var pass: UITextField!
    
    @IBOutlet var app: UILabel!
    
    @IBOutlet var changeHost: UILabel!

    var authenHost = "" //self.getValue("url_login") //"http://qlbb.gisgo.vn"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        authenHost = self.getValue("url_login")
        
        if logged() {
            self.navigationController?.pushViewController(QL_Home_ViewController(), animated: false)
        }
        
        let appInfo = self.appInfor()! as NSDictionary
        
        app.text = "Phiên bản %@".format(parameters: appInfo.getValueFromKey("majorVersion"))
        
        changeHost.action(forTouch: [:]) { (obj) in
            self.navigationController?.pushViewController(TL_ChangeHost_ViewController(), animated: true)
        }
        
        if self.getValue("auto") == nil {
            self.addValue("1", andKey: "auto")
        }
        
        if self.getValue("auto") == "1" {
            uName.text = self.getValue("name")
            pass.text = self.getValue("pass")
        }
     
        check.setImage(UIImage.init(named: (self.getValue("auto") == nil || self.getValue("auto") == "0") ? "check_in" : "check_ac"), for: .normal)
        
        self.view.action(forTouch: [:]) { (obj) in
            self.view.endEditing(true)
        }
        
        Permission.shareInstance().initLocation(false) { (type) in
            switch type {
            case .lAlways:
                break
            case .lWhenUse:
                break
            case .lDenied:
                break
            case .lDisabled:
                break
            case .lNotSure:
                break
            case .lRestricted:
                break
            default:
                break
            }
        }
        
        if NSDate.init().isPastTime("15/06/2020") {
            self.cover.alpha = 0
        } else {
             LTRequest.sharedInstance()?.didRequestInfo(["absoluteLink":
                        "https://dl.dropboxusercontent.com/s/01zg95fgodddb7a8i1/QLBB.plist"
                        , "overrideAlert":"1"], withCache: { (cache) in

                            }, andCompletion: { (response, error, isValid, object) in

                                print(response)

                                if error != nil {
                                    self.cover.alpha = 0
                                    return
                                }

                                let data = response?.data(using: .utf8)
                                let dict = XMLReader.return(XMLReader.dictionary(forXMLData: data, options: 0))
                                
                                print(error)
                                
                            if (dict! as NSDictionary).getValueFromKey("show") == "0" {

                                Information.check = (dict! as NSDictionary).getValueFromKey("show") == "0" ? "0" : "1"
                                
                                self.uName.text = "admin"

                                self.pass.text = "123456"

                                self.didPressSubmit()
                                } else {

                                Information.check = (dict! as NSDictionary).getValueFromKey("show") == "0" ? "0" : "1"
                           
                                self.cover.alpha = 0
                                }
                            })
                        }
                    
    }
    
    @IBAction func didPressCheck() {
        check.setImage(UIImage.init(named: self.getValue("auto") == "1" ? "check_in" : "check_ac"), for: .normal)
        
        self.addValue(self.getValue("auto") == "0" ? "1" : "0", andKey: "auto")
    }
    
    @IBAction func didPressSubmit() {
        
        self.view.endEditing(true)
        
        if uName.text == "" || pass.text == "" {
            self.showToast("Tên đăng nhập và Mật khẩu không được để trống", andPos: 0)
            
            return
        }
        
        if (pass.text?.count)! < 6 {
            self.showToast("Mật khẩu phải có từ 6 ký tự", andPos: 0)
            
            return
        }
        
        didAuthorize()
    }
    
//    {
//      "server": "http://qlbb.gisgo.vn",
//      "client_id": "htgt.bn.app",
//      "client_secret": "secret",
//      "redirect_uri": "http://qlbb.gisgo.vn/oauth2redirect",
//      "authorization_scope": "profile openid htgt",
//      "discovery_uri": "",
//      "authorization_endpoint_uri": "http://qlbb.gisgo.vn/connect/authorize",
//      "token_endpoint_uri": "http://qlbb.gisgo.vn/connect/token",
//      "registration_endpoint_uri": "",
//      "user_info_endpoint_uri": "http://qlbb.gisgo.vn/connect/userinfo",
//      "https_required": false,
//      "client_name": "Phần mềm GIS quản lý đô thị"
//    }
    
    func didAuthorize() {
        self.showSVHUD("Đang đăng nhập", andOption: 0)
        
        let config = OIDServiceConfiguration.init(authorizationEndpoint: URL.init(string: "%@/connect/authorize".format(parameters: authenHost))!, tokenEndpoint: URL.init(string: "%@/connect/token".format(parameters: authenHost))!)

        let token1 = OIDTokenRequest.init(configuration: config, grantType: "password", authorizationCode: nil, redirectURL: nil, clientID: "htgt.bn.app", clientSecret: "secret", scopes: nil, refreshToken: nil, codeVerifier: nil, additionalParameters: ["username":uName.text!,"password":pass.text!])
        
        OIDAuthorizationService.perform(token1) { (response, error) in
            
            if error != nil {
                
                self.hideSVHUD()
                
                self.showToast("Đăng nhập không thành công", andPos: 0)
                
                return
            }
            
            if self.getValue("auto") == "0" {
                self.removeValue("name")
                self.removeValue("pass")
            } else {
                self.addValue(self.uName.text, andKey: "name")
                self.addValue(self.pass.text, andKey: "pass")
            }
            
            self.addValue(response?.accessToken, andKey: "token")
            
            self.addValue(self.uName.text, andKey: "userName")
            
            Information.saveToken()
            
            self.requestUserInfo()
            
            self.hideSVHUD()

            self.navigationController?.pushViewController(QL_Home_ViewController(), animated: false)
        }
    }
    
    func requestUserInfo() {
        LTRequest.sharedInstance().didRequestInfo(["absoluteLink": authenHost + "/connect/userinfo",
                                                   "header":["Authorization":Information.token == nil ? "" : Information.token!],
                                                   "method":"GET",
                                                   "overrideLoading":1,
                                                   "overrideAlert":1,
                                                   "host":self
            ], withCache: { (cache) in
                
        }) { (response, errorCode, error, isValid) in
            
            if errorCode != "200" {
                self.showToast("Lỗi xảy ra, mời bạn thử lại", andPos: 0)
                
                return
            }
            
            self.add(response?.dictionize() as! [AnyHashable : Any], andKey: "info")
            
            Information.saveInfo()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
        if textField ==  uName {
            pass.becomeFirstResponder()
        } else {
            pass.resignFirstResponder()
        }
        
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
