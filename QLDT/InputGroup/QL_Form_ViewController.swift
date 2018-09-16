//
//  QL_Input_ViewController.swift
//  QLDT
//
//  Created by Thanh Hai Tran on 9/16/18.
//  Copyright © 2018 Thanh Hai Tran. All rights reserved.
//

import UIKit

class QL_Form_ViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var titleLabel: UILabel!
    
    var dataList: NSMutableArray!
    
    var configType: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = configType.getValueFromKey("title")
        
        tableView.withCell("TG_Cell")
        
        dataList = NSMutableArray()
        
        let images: NSMutableArray? = [["online":"", "Name":"Đường bộ", "title":"Biểu mẫu/Đường bộ", "Icon":"http://117.4.242.159:3334/images/mobiles/Duong_bo.png", "id":1], ["online":"", "Name":"Đường thủy", "title":"Biểu mẫu/Đường thủy", "Icon":"http://117.4.242.159:3334/images/mobiles/Duong_thuy.png", "id":3],["online":"", "Name":"Đường sắt", "title":"Biểu mẫu/Đường sắt", "Icon":"http://117.4.242.159:3334/images/mobiles/Duong_sat.png", "id":4]]
        
        dataList.addObjects(from: images as! [Any])
    }
    
    
    @IBAction func didPressBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension QL_Form_ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TG_Cell", for: indexPath)
        
        if dataList.count == 0 {
            return cell
        }
        
        let data = dataList![indexPath.row] as! NSDictionary
        
        (self.withView(cell, tag: 104) as! UIImageView).imageUrl(url: data.getValueFromKey("Icon"))
        
        (self.withView(cell, tag: 101) as! UILabel).text = "  %@".format(parameters: (data["Name"] as? String)!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let data = dataList![indexPath.row] as! NSDictionary
        
        let commonList = QL_Common_List_ViewController()
        
        commonList.configType = data
        
        self.navigationController?.pushViewController(commonList, animated: true)
    }
}

