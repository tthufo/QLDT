//
//  QL_Setting_ViewController.swift
//  QLDT
//
//  Created by Thanh Hai Tran on 9/2/18.
//  Copyright © 2018 Thanh Hai Tran. All rights reserved.
//

import UIKit

class QL_Setting_ViewController: UIViewController {

    @IBOutlet var menu: DropButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.getObject("timer") == nil {
            self.add(["title":"    1 phút", "value":1], andKey:"timer")
        }
        
        let setting = self.getObject("timer")["title"]
        
        menu.setTitle(setting as? String, for: .normal)
    }

    func getMenuList() -> [Any] {
        let array = NSMutableArray()
        
        for i in stride(from: 0, to: 65, by: 5) {
            array.add(["title":"    %i phút".format(parameters: i == 0 ? 1 : i), "time":i == 0 ? 1 : i])
        }
        
        return array as! [Any]
    }
    
    @IBAction func didPressBack() {
       self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didPressMenu(menu: DropButton) {
        menu.didDropDown(withData: getMenuList()) { (objc) in
            if objc != nil {
                let result = ((objc as! NSDictionary)["data"] as! NSDictionary)["title"]
                
                let time = (objc as! NSDictionary)["index"]

                
                menu.setTitle(result as? String, for: .normal)
                
                self.add(["title":result ?? "", "value":time], andKey: "timer")
                
                self.showToast("Cập nhật thành công", andPos: 0)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
