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
    
    func didRequestDetail(hasData: Bool, id: String, data: NSDictionary) {
        LTRequest.sharedInstance().didRequestInfo(["absoluteLink":"".urlGet(postFix: "api/Form/detail"),
                                                   "header":["Authorization":Information.token == nil ? "" : Information.token!],
                                                   "method":"GET",
                                                   "Getparam":["id":id],
                                                   "overrideLoading":1,
                                                   "overrideAlert":1,
                                                   "host":self
            ], withCache: { (cache) in
                
        }) { (response, errorCode, error, isValid) in
            
            if errorCode != "200" {
                self.showToast("Lỗi xảy ra, mời bạn thử lại", andPos: 0)
                
                return
            }
            
            let result = response?.dictionize()["Layer"]
                        
            let tagName = ["codeField":(result as! NSDictionary)["CodeField"], "labelField":(result as! NSDictionary)["LabelField"]]
            
            if hasData {
                let search = QL_Search_ViewController()

                search.icon = self.icon

                search.dataInfo = data
                                
                search.detail = response?.dictionize()
                
                search.tagName = tagName as NSDictionary

                self.navigationController?.pushViewController(search, animated: true)

                return
            }

            let formNew = QL_Form_New_ViewController()
            
            let currentCorr = self.latLng // Permission.shareInstance().currentLocation()! as NSDictionary

            formNew.detail = response?.dictionize()

            formNew.configType = ["title":(data["FormName"] as! String), "id":(data["Id"] as! NSNumber), "online":"", "coor": data.response(forKey: "lat") ? [["lat":data.getValueFromKey("lat"), "lng":data.getValueFromKey("lng")]] : [["lat":currentCorr.getValueFromKey("lat"), "lng":currentCorr.getValueFromKey("lng")]]]

            formNew.dataInfo = data

            self.present(formNew, animated: true) {

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

        let hasInclude = data.getValueFromKey("IncludeData") == "1"
        
        if hasInclude {
            (self.withView(cell, tag: 104) as! UIImageView).image = UIImage(named: "ic_fire")
        } else {
            (self.withView(cell, tag: 104) as! UIImageView).imageUrl(url: icon)
        }
        
        (self.withView(cell, tag: 101) as! UILabel).text = "  %@".format(parameters: (data["FormName"] as? String)!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let data = dataList![indexPath.row] as! NSDictionary
        
        let hasInclude = data.getValueFromKey("IncludeData") == "1"
        
        self.didRequestDetail(hasData: hasInclude, id: data.getValueFromKey("Id"), data: data)
        
//        if hasInclude {
//            let search = QL_Search_ViewController()
//
//            search.icon = self.icon
//
//            search.dataInfo = data
//
//            self.navigationController?.pushViewController(search, animated: true)
//
//            return
//        }
//
//        let formNew = QL_Form_New_ViewController()
//
//        formNew.configType = ["title":(data["FormName"] as! String), "id":(data["Id"] as! NSNumber), "online":""]
//
//        formNew.dataInfo = data
//
//        self.present(formNew, animated: true) {
//
//        }
        
//        let crash = QL_Crash_ViewController()
//        
//        crash.configType = ["title":(data["FormName"] as! String), "id":(data["Id"] as! NSNumber), "online":""]
//        
//        crash.delegate = self
//        
//        self.present(crash, animated: true) {
//            
//        }
    }
}

