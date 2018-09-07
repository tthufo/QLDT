//
//  QL_Comment_ViewController.swift
//  QLDT
//
//  Created by Mac on 9/7/18.
//  Copyright © 2018 Thanh Hai Tran. All rights reserved.
//

import UIKit

class QL_Comment_ViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var bar: UIView!
    
    @IBOutlet var chat: UIButton!
    
    var dataList: NSMutableArray!
    
    var checkUpData: NSDictionary!
    
    var kb: KeyBoard!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}


extension QL_Comment_ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QL_Check_Cell", for: indexPath)
        
        if dataList.count == 0 {
            return cell
        }
        
        let data = dataList![indexPath.row] as! NSDictionary
        
        
        
        
        let assets = self.withView(cell, tag: 10) as! UILabel
        
        assets.text = "Tên tài sản: %@".format(parameters: data.getValueFromKey("AssetName"))
        
        
        let code = self.withView(cell, tag: 11) as! UILabel
        
        code.text = "Mã: %@".format(parameters: data.getValueFromKey("AssetCode"))
        
        
        let layer = self.withView(cell, tag: 12) as! UILabel
        
        layer.text = "Lớp: %@".format(parameters: data.getValueFromKey("LayerName"))
        
        
        
        let check = self.withView(cell, tag: 13) as! UIButton
        
        check.setImage(UIImage.init(named: data.getValueFromKey("Checked") == "1" ? "check_ac_b" : "check_in_b"), for: .normal)
        
        check.action(forTouch: [:]) { (objc) in
            
            (self.dataList![indexPath.row] as! NSMutableDictionary)["Checked"] = (self.dataList![indexPath.row] as! NSMutableDictionary).getValueFromKey("Checked") == "1" ? "0" : "1"
            
            check.setImage(UIImage.init(named: ((self.dataList![indexPath.row] as! NSDictionary)["Checked"] as! String) == "1" ? "check_ac_b" : "check_in_b"), for: .normal)
        }
        
        let view = self.withView(cell, tag: 100) as! UIView
        
        if self.isMaintain() {
            view.updateConstraint(attribute: .height, constant: 0)
            
            for v in view.subviews {
                v.isHidden = true
            }
        }
        
        
        let text = self.withView(cell, tag: 14) as! UITextView
        
        text.delegate = self
        
        text.text = data.getValueFromKey("Description")
        
        text.accessibilityLabel = "%i".format(parameters: indexPath.row)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}

