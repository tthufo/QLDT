//
//  TL_ChangeHost_ViewController.swift
//  QLDT
//
//  Created by Thanh Hai Tran on 7/28/18.
//  Copyright © 2018 Thanh Hai Tran. All rights reserved.
//

import UIKit

class TL_ChangeHost_ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var host: UITextField!
    
    @IBOutlet var authen: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        host.text = self.getValue("url")
        
        authen.text = self.getValue("url_login")
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        
        return true
    }
    
    @IBAction func didPressSubmi() {
        if host.text == "" || authen.text == "" {
            self.showToast("Bạn cần nhập địa chỉ máy chủ và địa chỉ đăng nhập", andPos: 0)
            
            return
        }
        
        self.addValue(host.text, andKey: "url")
        
        self.addValue(authen.text, andKey: "url_login")
        
        self.showToast("Cập nhật địa chỉ thành công.", andPos: 0)
        
        self.view.endEditing(true)
    }
    
    @IBAction func didPressBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
