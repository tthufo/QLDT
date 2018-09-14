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


        let temp0: NSArray = [["title":"Mã vị trí tai nạn", "data":"", "ident":"QL_Input_Cell"],
                    ["title":"Địa chỉ", "data":"", "ident":"QL_Input_Cell"],
                    ["title":"Vị trí", "data":"", "ident":"QL_Drop_Cell"],
                    ["title":"Thời gian", "data":"", "ident":"QL_Calendar_Cell"],
                    ["title":"Hiện trạng", "data":"", "ident":"QL_Input_Cell"],
                    ["title":"Số hiệu đường", "data":"", "ident":"QL_Input_Cell"],
                    ["title":"Phân loại", "data":"", "ident":"QL_Input_Cell"],
                    ["title":"Tọa độ", "data":[], "ident":"QL_Location_Cell"],
                    ["title":"Ảnh minh họa", "data":"", "ident":"QL_Image_Cell"],
        ]
        
        let temp1: NSArray = [["title":"Mã tài sản", "data":"", "ident":"QL_Input_Cell"],
                             ["title":"Thời gian", "data":"", "ident":"QL_Calendar_Cell"],
                             ["title":"Tọa độ", "data":[], "ident":"QL_Location_Cell"],
                             ["title":"Mã vị trí sự cố", "data":"", "ident":"QL_Input_Cell"],
                             ["title":"Địa chỉ", "data":"", "ident":"QL_Input_Cell"],
                             ["title":"Vị trí", "data":"", "ident":"QL_Drop_Cell"],
                             ["title":"Ghi chú", "data":"", "ident":"QL_Input_Cell"],
                             ["title":"Hiện trạng", "data":"", "ident":"QL_Drop_Cell"],
                             ["title":"Số hiệu đường", "data":"", "ident":"QL_Input_Cell"],
                             ["title":"Phân loại", "data":"", "ident":"QL_Drop_Cell"],
                             ["title":"Ảnh minh họa", "data":"", "ident":"QL_Image_Cell"],
        ]
        
        let temp2: NSArray = [["title":"Mã tài sản", "data":"", "ident":"QL_Input_Cell"],
                              ["title":"Tọa độ", "data":[], "ident":"QL_Location_Cell"],
                              ["title":"Mã điểm phản hồi", "data":"", "ident":"QL_Input_Cell"],
                              ["title":"Địa chỉ", "data":"", "ident":"QL_Input_Cell"],
                              ["title":"Vị trí", "data":"", "ident":"QL_Drop_Cell"],
                              ["title":"Mã khách hàng", "data":"", "ident":"QL_Input_Cell"],
                              ["title":"Ghi chú", "data":"", "ident":"QL_Input_Cell"],
                              ["title":"Trạng thái xử lý", "data":"", "ident":"QL_Input_Cell"],
                              ["title":"Hiện trạng", "data":"", "ident":"QL_Drop_Cell"],
                              ["title":"Phân loại", "data":"", "ident":"QL_Drop_Cell"],
                              ["title":"Số hiệu đường", "data":"", "ident":"QL_Input_Cell"],
                              ["title":"Thời gian", "data":"", "ident":"QL_Calendar_Cell"],
        ]
        
        dataList = NSMutableArray()
        
        if configType.getValueFromKey("type") == "0" {
            dataList.addObjects(from: temp0.withMutable())
        }
        
        if configType.getValueFromKey("type") == "1" {
            dataList.addObjects(from: temp1.withMutable())
        }
        
        if configType.getValueFromKey("type") == "2" {
            dataList.addObjects(from: temp2.withMutable())
        }
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
        self.dismiss(animated: true) {

        }
    }
    
    func didAskForMedia(indexing: String) {
        Permission.shareInstance().askGallery { (camType) in
            switch (camType) {
            case .authorized:
                Media.shareInstance().startPickImage(withOption: false, andBase: nil, andRoot: self, andCompletion: { (image) in
                    self.saveImage(image: image as! UIImage, indexing: indexing)
                })
                break
            case .denied:
                self.showToast("Bạn chưa cho phép sử dụng Bộ sưu tập", andPos: 0)
                break
            case .per_denied:
                self.showToast("Bạn chưa cho phép sử dụng Bộ sưu tập", andPos: 0)
                break
            case .per_granted:
                Media.shareInstance().startPickImage(withOption: false, andBase: nil, andRoot: self, andCompletion: { (image) in
                    self.saveImage(image: image as! UIImage, indexing: indexing)
                })
                break
            case .restricted:
                self.showToast("Bạn chưa cho phép sử dụng Bộ sưu tập", andPos: 0)
                break
            default:
                break
            }
        }
    }
    
    func didAskForCamera(indexing: String) {
        Permission.shareInstance().askCamera { (camType) in
            switch (camType) {
            case .authorized:
                Media.shareInstance().startPickImage(withOption: true, andBase: nil, andRoot: self, andCompletion: { (image) in
                    self.saveImage(image: image as! UIImage, indexing: indexing)
                })
                break
            case .denied:
                self.showToast("Bạn chưa cho phép sử dụng Bộ sưu tập", andPos: 0)
                break
            case .per_denied:
                self.showToast("Bạn chưa cho phép sử dụng Bộ sưu tập", andPos: 0)
                break
            case .per_granted:
                Media.shareInstance().startPickImage(withOption: true, andBase: nil, andRoot: self, andCompletion: { (image) in
                    self.saveImage(image: image as! UIImage, indexing: indexing)
                })
                break
            case .restricted:
                self.showToast("Bạn chưa cho phép sử dụng Bộ sưu tập", andPos: 0)
                break
            default:
                break
            }
        }
    }
    
    func saveImage(image: UIImage, indexing: String) {
        (dataList[Int(indexing)!] as! NSMutableDictionary)["data"] = image.imageString()
        
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension QL_Crash_ViewController: CalendarDelegate {
    func didChooseCalendar(_ date: String!, and title: String!) {
        
        (dataList[Int(title)!] as! NSMutableDictionary)["data"] = date
        
        self.tableView.reloadData()
    }
}

extension QL_Crash_ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let indexing = Int(textField.accessibilityLabel!)
        
        if let text = textField.text as NSString? {
            let txtAfterUpdate = text.replacingCharacters(in: range, with: string)
            
            (dataList[indexing!] as! NSMutableDictionary)["data"] = txtAfterUpdate
        }
        
        return true
    }
}

extension QL_Crash_ViewController: MapDelegate {
    
    func didReloadData(data: NSArray, indexing: String) {
        
        if data.count == 0 {
            return
        }
        
        (dataList[Int(indexing)!] as! NSMutableDictionary)["data"] = data
        
        self.tableView.reloadData()
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

        (self.withView(cell, tag: 1) as! UILabel).text = data["title"] as? String

        
        
        
        if data["ident"] as! String == "QL_Input_Cell" {
            let input = (self.withView(cell, tag: 2) as! UITextField)
            
            input.accessibilityLabel = "%i".format(parameters: indexPath.row)
            
            input.delegate = self
            
            input.text = data["data"] as? String
        }
        
        if data["ident"] as! String == "QL_Drop_Cell" {
            let drop = (self.withView(cell, tag: 2) as! DropButton)
            
            drop.action(forTouch: [:]) { (objc) in
                drop.didDropDown(withData: [["title":"ahihi"]], andCompletion: { (result) in
                    
                })
            }
        }
        
        if data["ident"] as! String == "QL_Calendar_Cell" {
            let cal = (self.withView(cell, tag: 2) as! UIImageView)
            
            cal.action(forTouch: [:]) { (objc) in
                let cal = MNViewController.init(calendar: Calendar.init(identifier: .gregorian), title: "%i".format(parameters: indexPath.row))
        
                cal?.delegate = self
        
                self.present(cal!, animated: true) {
        
                }
            }
            
            let date = (self.withView(cell, tag: 3) as! UILabel)
            
            date.text = data["data"] as? String
        }
        
        if data["ident"] as! String == "QL_Location_Cell" {
            let loc = (self.withView(cell, tag: 2) as! UIImageView)
            
            loc.action(forTouch: [:]) { (objc) in
                let map = QL_Map_ViewController()
                
                map.indexing = "%i".format(parameters: indexPath.row)
                
                map.delegate = self
                
                self.present(map, animated: true, completion: {
                    
                })
            }
            
            if (data["data"] as! NSArray).count != 0 {
                
                let coor = (data["data"] as! NSArray).firstObject as! NSDictionary
                
                let X = (self.withView(cell, tag: 3) as! UILabel)
                
                X.text = coor["lat"] as? String
                
                let Y = (self.withView(cell, tag: 4) as! UILabel)
                
                Y.text = coor["lng"] as? String
            }
        }
        
        if data["ident"] as! String == "QL_Image_Cell" {
            
            let gallery = (self.withView(cell, tag: 2) as! UIButton)
            
            gallery.action(forTouch: [:]) { (objc) in
                self.didAskForMedia(indexing: "%i".format(parameters: indexPath.row))
            }
            
            let cam = (self.withView(cell, tag: 3) as! UIButton)
            
            cam.action(forTouch: [:]) { (objc) in
                self.didAskForCamera(indexing: "%i".format(parameters: indexPath.row))
            }
            
            let image = (self.withView(cell, tag: 4) as! UIImageView)
            
            if data["data"] as! String != "" {
                image.image = (data["data"] as! String).stringImage()
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
