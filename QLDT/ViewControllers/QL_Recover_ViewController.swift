//
//  QL_Recover_ViewController.swift
//  QLDT
//
//  Created by Thanh Hai Tran on 9/2/18.
//  Copyright © 2018 Thanh Hai Tran. All rights reserved.
//

import UIKit

class QL_Recover_ViewController: UIViewController {

    @IBOutlet var old: UITextField!
    
    @IBOutlet var new: UITextField!

    @IBOutlet var reNew: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.action(forTouch: [:]) { (obj) in
            self.view.endEditing(true)
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField ==  old  {
            new.becomeFirstResponder()
        } else if textField ==  new {
            reNew.becomeFirstResponder()
        } else {
            reNew.resignFirstResponder()
        }
        
        return true
    }
    
    @IBAction func didPressBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didRecoverPass() {
        if !old.hasText || !new.hasText || !reNew.hasText {
            self.showToast("Bạn phải nhập đủ thông tin", andPos: 0)
            return
        }
        
        if (old.text?.count)! < 6 || (new.text?.count)! < 6 || (reNew.text?.count)! < 6 {
            self.showToast("Thông tin nhập phải lớn hơn 6 ký tự", andPos: 0)
            return
        }
        
        if new.text != reNew.text {
            self.showToast("Mật khẩu mới không trùng", andPos: 0)
            return
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
