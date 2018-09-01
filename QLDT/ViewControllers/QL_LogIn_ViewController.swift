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
    
    @IBOutlet var uName: UITextField!
    
    @IBOutlet var pass: UITextField!
    
    @IBOutlet var app: UILabel!
    
    @IBOutlet var changeHost: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        let appInfo = self.appInfor()! as NSDictionary
        
        app.text = "Phiên bản %@".format(parameters: appInfo.getValueFromKey("majorVersion"))
        
        changeHost.action(forTouch: [:]) { (obj) in
            self.navigationController?.pushViewController(TL_ChangeHost_ViewController(), animated: true)
        }
        
        if self.getValue("auto") == nil {
            self.addValue("1", andKey: "auto")
        }
        
        check.setImage(UIImage.init(named: (self.getValue("auto") == nil || self.getValue("auto") == "0") ? "check_in" : "check_ac"), for: .normal)
        
        self.view.action(forTouch: [:]) { (obj) in
            self.view.endEditing(true)
        }
    }
    
    @IBAction func didPressCheck() {
        check.setImage(UIImage.init(named: self.getValue("auto") == "1" ? "check_in" : "check_ac"), for: .normal)
        
        self.addValue( self.getValue("auto") == "0" ? "1" : "0", andKey: "auto")
    }
    
    @IBAction func didPressSubmit() {
        
        self.view.endEditing(true)
        
        self.navigationController?.pushViewController(QL_Home_ViewController(), animated: true)
        
        if uName.text == "" || pass.text == "" {
            self.showToast("Tên đăng nhập và Mật khẩu không được để trống", andPos: 0)
            
            return
        }
        
        if (pass.text?.count)! < 6 {
            self.showToast("Mật khẩu phải có từ 6 ký tự", andPos: 0)
            
            return
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
