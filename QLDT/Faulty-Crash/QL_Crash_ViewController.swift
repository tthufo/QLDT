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
    
    var kb: KeyBoard!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kb = KeyBoard.shareInstance()
        
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        kb.keyboardOff()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        kb.keyboard{ (height, isOn) in
            
            self.tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: isOn ? height : 0, right: 0)
        }
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

extension QL_Crash_ViewController: CalendarDelegate {
    func didChooseCalendar(_ date: Date!) {
        print(date)
    }
}

extension QL_Crash_ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        
        return true
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

        (self.withView(cell, tag: 1) as! UILabel).text = data["title"] as! String

        
        
        
        if data["ident"] as! String == "QL_Input_Cell" {
            (self.withView(cell, tag: 2) as! UITextField).delegate = self
        }
        
        if data["ident"] as! String == "QL_Drop_Cell" {
            let drop = (self.withView(cell, tag: 2) as! DropButton)
            
            drop.action(forTouch: [:]) { (objc) in
                drop.didDropDown(withData: [["title":"ahihi"]], andCompletion: { (result) in
                    print(result)
                })
            }
        }
        
        if data["ident"] as! String == "QL_Calendar_Cell" {
            let cal = (self.withView(cell, tag: 2) as! UIImageView)
            
            cal.action(forTouch: [:]) { (objc) in
                let cal = MNViewController.init(calendar: Calendar.init(identifier: .gregorian), title: "")
        
                cal?.delegate = self
        
                self.present(cal!, animated: true) {
        
                }
            }
            
            let date = (self.withView(cell, tag: 3) as! UILabel)
        }
        
        if data["ident"] as! String == "QL_Location_Cell" {
            let loc = (self.withView(cell, tag: 2) as! UIImageView)
            
            loc.action(forTouch: [:]) { (objc) in
                let map = QL_Map_ViewController()
                
                
                self.present(map, animated: true, completion: {
                    
                })
            }
            
            let X = (self.withView(cell, tag: 3) as! UILabel)
            
            let Y = (self.withView(cell, tag: 4) as! UILabel)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
