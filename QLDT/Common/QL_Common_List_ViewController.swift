//
//  QL_Common_List_ViewController.swift
//  QLDT
//
//  Created by Mac on 9/6/18.
//  Copyright © 2018 Thanh Hai Tran. All rights reserved.
//

import UIKit

class QL_Common_List_ViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var titleLabel: UILabel!
    
    var dataList: NSMutableArray!
    
    var configType: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = configType.getValueFromKey("title")
        
        tableView.withCell("TG_Cell")
        
        dataList = NSMutableArray()
        
        if configType.response(forKey: "url") {
            didRequest()
        } else {
            getData()
        }
    }

    func getData() {
        
        let arr = Field.getDataModule(moduleId: self.configType["id"] as! Int32)
        
        dataList.removeAllObjects()
        
        dataList.addObjects(from: arr)
        
        self.tableView.reloadData()
    }
    
    func didRequest() {
        if self.configType.getValueFromKey("url") == "" {

        } else {
            LTRequest.sharedInstance().didRequestInfo(["absoluteLink":"".urlGet(postFix: self.configType.getValueFromKey("url")),
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
            
                self.dataList.removeAllObjects()
                
                self.dataList.addObjects(from: response?.dictionize()["array"] as! [Any])
                
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func didPressBack() {
        self.navigationController?.popViewController(animated: true)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension QL_Common_List_ViewController: UITableViewDataSource, UITableViewDelegate {
    
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
        
        let isModule = !configType.response(forKey: "url")
        
        if !isModule {
            (self.withView(cell, tag: 104) as! UIImageView).image = UIImage.init(named: (configType["img"] as? String)!)
        } else {
            (self.withView(cell, tag: 104) as! UIImageView).imageUrl(url: data.getValueFromKey("Icon"))
        }

        (self.withView(cell, tag: 101) as! UILabel).text = "  %@".format(parameters: (data[isModule ? "Description" : "Name"] as? String)!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let data = dataList![indexPath.row] as! NSDictionary

        let isOnline = configType.response(forKey: "online")

        if isOnline {
            
            let online = QL_Online_ViewController()
            
            online.icon = data.getValueFromKey("Icon")
                
            online.configType = ["title":data["Description"] as! String]
            
            online.data = data
            
            self.navigationController?.pushViewController(online, animated: true)
            
            return
        }
        
        let isModule = !configType.response(forKey: "url")

        
        if isModule {
            let list = QL_List_ViewController()
            
            list.configType = ["title":data["Description"] ?? "", "id":data["Id"] as! Int32]
            
            self.navigationController?.pushViewController(list, animated: true)
        } else {
            let checkUp = QL_Maintain_CheckUp_ViewController()
            
            checkUp.checkUpData = data
            
            self.navigationController?.pushViewController(checkUp, animated: true)
        }
    }
}

