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
    
    @IBOutlet var textField: UITextField!
    
    var dataList: NSMutableArray!
    
    var checkUpData: NSDictionary!
    
    var kb: KeyBoard!
    
    @IBOutlet var bottom: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        kb = KeyBoard.shareInstance()
        
        tableView.withCell("QL_Comment_Cell")

        dataList = NSMutableArray()
        
        didRequestMessage()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tableView.estimatedRowHeight = 60
        
        tableView.rowHeight = UITableViewAutomaticDimension
        
        kb.keyboardOff()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        kb.keyboard { (height, isOn) in
         
            self.bottom.constant = isOn ? height : 0
        }
    }
    
    func didRequestSend() {
        LTRequest.sharedInstance().didRequestInfo(["absoluteLink":"".urlGet(postFix: "api/Maintain/putChatMessage"),
                                                   "header":["Authorization":Information.token == nil ? "" : Information.token!],
                                                   "Id":"0",
                                                   "MaintenanceId":checkUpData["Id"],
                                                   "Message":self.textField.text,
                                                   "Time":NSDate().string(withFormat: "yyyy-MM-dd'T'HH:mm:ss"),
                                                   "User":NSNull(),
                                                   "UserId":checkUpData["Inspector"],
                                                   "host":self,
                                                   "overrideLoading":1,
                                                   "overrideAlert":1], withCache: { (cache) in
                                                    
        }) { (response, errorCode, error, isValid) in
            
            if errorCode != "200" {
                self.showToast("Lỗi xảy ra, mời bạn thử lại", andPos: 0)
                
                return
            }
            
            self.didRequestMessage()

            self.perform(#selector(self.didScrollToBottom), with: self, afterDelay: 0.5)
        }
    }
    
    @objc func didScrollToBottom() {
        self.tableView.didScrolltoBottom(true)
    }
    
    @IBAction func didRequestMessage() {
        LTRequest.sharedInstance().didRequestInfo(["absoluteLink":"".urlGet(postFix: "api/Maintain/listChat"),
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

            let results = response?.dictionize()["array"] as! NSArray

            self.dataList.addObjects(from: results as! [Any])

            self.tableView.reloadData()
        }
    }
    
    @IBAction func didPressBack() {
        self.dismiss(animated: true) {
            
        }
    }
    
    @IBAction func didPressSend() {
        if !self.textField.hasText {
            return
        }
        
        self.textField.text = ""
        
        didRequestSend()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension QL_Comment_ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "QL_Comment_Cell", for: indexPath)
        
        if dataList.count == 0 {
            return cell
        }
        
        let data = dataList[indexPath.row] as! NSDictionary
        
        let isMe = (data["User"] as! NSDictionary)["UserName"] as? String == Information.userName

        
        let dayLeft = self.withView(cell, tag: 10) as! UILabel
        
        dayLeft.text = data.getValueFromKey("Time")
        
        let contentLeft = self.withView(cell, tag: 11) as! UILabel

        contentLeft.text = isMe ? data.getValueFromKey("Message") : ""

        let dayRight = self.withView(cell, tag: 20) as! UILabel
        
        dayRight.text = data.getValueFromKey("Time")

        let contentRight = self.withView(cell, tag: 21) as! UILabel
        
        contentRight.text = !isMe ? data.getValueFromKey("Message") : ""

        
        dayLeft.isHidden = !isMe
        
        contentLeft.isHidden = !isMe
        
        dayRight.isHidden = isMe
        
        contentRight.isHidden = isMe
        

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}

