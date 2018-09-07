//
//  GL_Maintain_CheckUp_ViewController.swift
//  QLDT
//
//  Created by Mac on 9/7/18.
//  Copyright © 2018 Thanh Hai Tran. All rights reserved.
//

import UIKit

class QL_Maintain_CheckUp_ViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var titleLabel: UILabel!
    
    var dataList: NSMutableArray!
    
    var checkUpData: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = checkUpData.getValueFromKey("Name")
        
        tableView.withCell("QL_Check_Cell")
        
        dataList = NSMutableArray()
        
        didRequest()
    }
    
    //http://117.4.242.159:3333/api/Maintain/detail?id=1039
    
    //http://117.4.242.159:3333/api/Maintain/listChat?id=1041
    
//    http://117.4.242.159:3333/api/Maintain/putChatMessage   {
//    "Id": 0,
//    "MaintenanceId": 1041,
//    "Message": "dsfdsfd",
//    "Time": "2018-09-07T10:10:08Z",
//    "User": null,
//    "UserId": "f92db026-7c7d-4143-98bf-a572da41c950"
//}
    // IsMaintenance
    
    
    func didRequest() {
        LTRequest.sharedInstance().didRequestInfo(["absoluteLink":"".urlGet(postFix: "api/Maintain/detail"),
                                                   "header":["Authorization":Information.token == nil ? "" : Information.token!],
                                                   "Getparam":["id":checkUpData["Id"]],
                                                   "method":"GET",
                                                   "overrideAlert":"1"], withCache: { (cache) in
                                                    
        }) { (response, errorCode, error, isValid) in
            
            if errorCode != "200" {
                self.showToast("Lỗi xảy ra, mời bạn thử lại", andPos: 0)
                
                return
            }
            
            //self.dataList.removeAllObjects()
            
           //// self.dataList.addObjects(from: response?.dictionize()["array"] as! [Any])
            
            //self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
        
        tableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    @IBAction func didPressBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension QL_Maintain_CheckUp_ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2//dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QL_Check_Cell", for: indexPath)
        
        if dataList.count == 0 {
            return cell
        }
        
        let data = dataList![indexPath.row] as! NSDictionary
        
       
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}

