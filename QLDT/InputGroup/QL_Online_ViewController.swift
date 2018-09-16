//
//  QL_Online_ViewController.swift
//  QLDT
//
//  Created by Thanh Hai Tran on 9/17/18.
//  Copyright © 2018 Thanh Hai Tran. All rights reserved.
//

import UIKit

class QL_Online_ViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var titleLabel: UILabel!
    
    var dataList: NSMutableArray!
    
    var configType: NSDictionary!
    
    var data: NSDictionary!

    var icon: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = configType.getValueFromKey("title")
        
        tableView.withCell("TG_Cell")
        
        dataList = NSMutableArray()
        
        didRequest()
    }
    
    func didRequest() {
        LTRequest.sharedInstance().didRequestInfo(["absoluteLink":"".urlGet(postFix: "/api/Form/listByLayer"),
                                                   "header":["Authorization":Information.token == nil ? "" : Information.token!],
                                                   "method":"GET",
                                                   "Getparam":["layerId":data["LayerId"], "moduleId":data["ModuleId"]],
                                                   "overrideLoading":1,
                                                   "overrideAlert":1,
                                                   "host":self
            ], withCache: { (cache) in
                
        }) { (response, errorCode, error, isValid) in
            
            if errorCode != "200" {
                self.showToast("Lỗi xảy ra, mời bạn thử lại", andPos: 0)
                
                return
            }
            
            self.dataList.removeAllObjects()
            
            self.dataList.addObjects(from: response?.dictionize()["array"] as! [Any])
            
            self.tableView.reloadData()
        }
    }
    
    @IBAction func didPressBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension QL_Online_ViewController: EditDelegate {
    func editDidReloadData(data: NSDictionary) {
        
    }
}

extension QL_Online_ViewController: UITableViewDataSource, UITableViewDelegate {
    
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

        (self.withView(cell, tag: 104) as! UIImageView).imageUrl(url: icon)

        (self.withView(cell, tag: 101) as! UILabel).text = "  %@".format(parameters: (data["FormName"] as? String)!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let data = dataList![indexPath.row] as! NSDictionary
        
        let crash = QL_Crash_ViewController()
        
        crash.configType = ["title":(data["FormName"] as! String), "id":(data["Id"] as! NSNumber), "online":""]
        
        crash.delegate = self
        
        self.present(crash, animated: true) {
            
        }
    }
}

