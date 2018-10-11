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
    
    @IBOutlet var bar: UIView!
    
    @IBOutlet var chat: UIButton!

    var dataList: NSMutableArray!
    
    var checkUpData: NSDictionary!
    
    var kb: KeyBoard!

    var timer: Timer!

    var count = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetCount()
        
        kb = KeyBoard.shareInstance()

        titleLabel.text = checkUpData.getValueFromKey("Name")
        
        tableView.withCell("QL_Check_Cell")
        
        dataList = NSMutableArray()
        
        tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 50, right: 0)
        
        chat.isHidden = !isMaintain()
        
        didRequest()
        
        if !isMaintain() {
            didTracking()
            
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(update), userInfo: nil, repeats: true)
        }
    }
    
    @objc func update() {
        
        if(count == 0) {
        
            didTracking()
            
            resetCount()
            
            timer.invalidate()
            
            timer = nil
            
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(update), userInfo: nil, repeats: true)
        }
        
        count -= 1
    }
    
    func resetCount() {
        count = 60
    }
    
    func isMaintain() -> Bool {
        return checkUpData["IsMaintenance"] as! Bool
    }
    
    func latLng() -> CLLocationCoordinate2D {
        let currentCorr = Permission.shareInstance().currentLocation()
        
        return CLLocationCoordinate2D(latitude: (currentCorr!["lat"]! as! NSNumber).doubleValue , longitude: (currentCorr!["lng"]! as! NSNumber).doubleValue)
    }
    
    func didTracking() {
        LTRequest.sharedInstance().didRequestInfo(["absoluteLink":"".urlGet(postFix: "api/Tracking/Push"),
                                                   "header":["Authorization":Information.token == nil ? "" : Information.token!],
                                                   "Postparam":[["Id": checkUpData["Id"],
                                                                 "Lat": latLng().latitude,
                                                                 "Lng": latLng().longitude,
                                                                 "MaintenanceId": checkUpData["Id"],
                                                                 "Time": Date().toMillis(),
                                                                 "UserId": checkUpData["UserId"]]],
                                                   "overrideAlert":1], withCache: { (cache) in
                                                    
        }) { (response, errorCode, error, isValid) in
            
            if errorCode != "200" {                
                return
            }
            
            print(response)
        }
    }
    
    func didRequest() {
        LTRequest.sharedInstance().didRequestInfo(["absoluteLink":"".urlGet(postFix: "api/Maintain/detail"),
                                                   "header":["Authorization":Information.token == nil ? "" : Information.token!],
                                                   "Getparam":["id":checkUpData["Id"]],
                                                   "method":"GET",
                                                   "host":self,
                                                   "overrideLoading":1,
                                                   "overrideAlert":1], withCache: { (cache) in
                                                    
        }) { (response, errorCode, error, isValid) in
            
            if errorCode != "200" {
                self.showToast("Lỗi xảy ra, mời bạn thử lại", andPos: 0)
                
                return
            }
            
            self.dataList.removeAllObjects()
            
            let results = response?.dictionize().reFormat()["MaintenanceAssets"] as! NSArray

            self.dataList.addObjects(from: results as! [Any])
            
            self.tableView.reloadData()
        }
    }
    
    func toolBar() -> UIToolbar {

        let toolBar = UIToolbar.init(frame: CGRect.init(x: 0, y: 0, width: Int(self.screenWidth()), height: 50))

        toolBar.barStyle = .default

        toolBar.items = [UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                         UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                         UIBarButtonItem.init(title: "Thoát", style: .done, target: self, action: #selector(disMiss))]
        return toolBar
    }

    @objc func disMiss() {
        self.view.endEditing(true)
    }
    
    func didRequestUpdate() {
        
        let postData = NSMutableArray()
        
        for dict in dataList {
            
            (dict as! NSMutableDictionary)["Layer"] = NSNull()
            
            (dict as! NSMutableDictionary)["Checked"] = (dict as! NSMutableDictionary).getValueFromKey("Checked") == "1" ? true : false
            
            postData.add(dict)
        }
        
        LTRequest.sharedInstance().didRequestInfo(["absoluteLink":"".urlGet(postFix: "api/Maintain/updateAssets"),
                                                   "header":["Authorization":Information.token == nil ? "" : Information.token!],
                                                   "Postparam":postData,
                                                   "host":self,
                                                   "overrideLoading":1,
                                                   "overrideAlert":1], withCache: { (cache) in
                                                    
        }) { (response, errorCode, error, isValid) in
            
            if errorCode != "200" {
                self.showToast("Lỗi xảy ra, mời bạn thử lại", andPos: 0)
                
                return
            }
            
            if response?.dictionize().getValueFromKey("success") == "1" {
                self.navigationController?.popViewController(animated: true)
                
                self.showToast("Cập nhật thành công", andPos: 0)
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if timer != nil {
            timer.invalidate()
            
            timer = nil
        }
        
        kb.keyboardOff()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                
        tableView.rowHeight = UITableViewAutomaticDimension
        
        kb.keyboard{(height, isOn) in

            self.tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: isOn ? height + 0 : 50, right: 0)
        }
    }
    
    @IBAction func didPressBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didPressDismiss() {
        self.view.endEditing(true)
    }
    
    @IBAction func didPressUpdate() {
        didRequestUpdate()
    }
    
    @IBAction func didPressChat() {
        let comment = QL_Comment_ViewController()
        
        comment.checkUpData = self.checkUpData
        
        self.present(comment, animated: true) {
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension QL_Maintain_CheckUp_ViewController: UITextViewDelegate {

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let indexing = Int(textView.accessibilityLabel!)
        
        (dataList[indexing!] as! NSMutableDictionary)["Description"] = textView.text
        
        return true
    }
}

extension QL_Maintain_CheckUp_ViewController: UITableViewDataSource, UITableViewDelegate {
    
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
 
        text.inputAccessoryView = self.toolBar()
        
        text.delegate = self
        
        text.text = data.getValueFromKey("Description")
        
        text.accessibilityLabel = "%i".format(parameters: indexPath.row)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}

