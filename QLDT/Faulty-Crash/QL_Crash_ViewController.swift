//
//  QL_Crash_ViewController.swift
//  QLDT
//
//  Created by Thanh Hai Tran on 9/11/18.
//  Copyright © 2018 Thanh Hai Tran. All rights reserved.
//

import UIKit

class QL_Crash_ViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var titleLabel: UILabel!
    
    var dataList: NSMutableArray!
    
    var configType: NSDictionary!
    
    var dataType: NSMutableDictionary!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = configType.getValueFromKey("title")
        
        tableView.withCell("QL_Input_Cell")
        
        tableView.withCell("QL_Drop_Cell")
        
        tableView.withCell("QL_Calendar_Cell")

        tableView.withCell("QL_Location_Cell")

        tableView.withCell("QL_Image_Cell")


        dataList = [["title":"Mã vị trí tai nạn", "data":"", "ident":"QL_Input_Cell"],
                    ["title":"Địa chỉ", "data":"", "ident":"QL_Input_Cell"],
                    ["title":"Vị trí", "data":"", "ident":"QL_Drop_Cell"],
                    ["title":"Thời gian", "data":"", "ident":"QL_Calendar_Cell"],
                    ["title":"Hiện trạng", "data":"", "ident":"QL_Input_Cell"],
                    ["title":"Số hiệu đường", "data":"", "ident":"QL_Input_Cell"],
                    ["title":"Phân loại", "data":"", "ident":"QL_Input_Cell"],
                    ["title":"Tọa độ", "data":"", "ident":"QL_Location_Cell"],
                    ["title":"Ảnh minh họa", "data":"", "ident":"QL_Image_Cell"],
        ]

        dataType = [:]
        
        print(configType)
    }
    
    @IBAction func didRequestSubmit() {
//        LTRequest.sharedInstance().didRequestInfo(["absoluteLink":"".urlGet(postFix: configType.getValueFromKey("url")),
//                                                   "header":["Authorization":Information.token == nil ? "" : Information.token!],
//                                                   "method":"GET",
//                                                   "overrideLoading":1,
//                                                   "overrideAlert":1,
//                                                   "host":self
//            ], withCache: { (cache) in
//
//        }) { (response, errorCode, error, isValid) in
//
//            if errorCode != "200" {
//                self.showToast("Lỗi xảy ra, mời bạn thử lại", andPos: 0)
//
//                return
//            }
//
//            self.dataList.removeAllObjects()
//
//            self.dataList.addObjects(from: response?.dictionize()["array"] as! [Any])
//
//            self.tableView.reloadData()
//        }
    }
    
    @IBAction func didPressBack() {
//        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true) {
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension QL_Crash_ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: (dataList[indexPath.row] as! NSDictionary)["ident"] as! String, for: indexPath)
        
        if dataList.count == 0 {
            return cell
        }
        
        let data = dataList![indexPath.row] as! NSDictionary
//
//        (self.withView(cell, tag: 104) as! UIImageView).image = UIImage.init(named: (configType["img"] as? String)!)
//
        (self.withView(cell, tag: 1) as! UILabel).text = data["title"] as! String
//
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
