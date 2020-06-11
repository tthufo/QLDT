//
//  QL_Search_ViewController.swift
//  QLDT
//
//  Created by Thanh Hai Tran on 10/4/18.
//  Copyright © 2018 Thanh Hai Tran. All rights reserved.
//

import UIKit

class QL_Search_ViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var titleLabel: UILabel!
    
    var dataList: NSMutableArray!
    
    var dataInfo: NSDictionary!
    
    var detail: NSDictionary!
    
    var tagName: NSDictionary!
    
    var icon: String!
    
    @IBOutlet var search: UITextField!
    
    @IBOutlet var distance: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.titleLabel.text = dataInfo["FormName"] as? String
        
        self.tableView.withCell("TG_Cell")
        
        self.distance.inputAccessoryView = self.toolBar()
        
        didRequest()
        
        dataList = NSMutableArray()
    }
    
    func didRequest() {
        
        let distance = self.distance.text
        
        let currentCorr = self.latLng // Permission.shareInstance().currentLocation()
        
        LTRequest.sharedInstance().didRequestInfo(["absoluteLink":"".urlGet(postFix: "/api/Data/Filter"),
                                                   "header":["Authorization":Information.token == nil ? "" : Information.token!],
                                                   "method":"GET",
                                                   "Getparam":["radius": distance == "" ? 10000 : distance, "lat":currentCorr["lat"], "lng":currentCorr["lng"]!, "keyword":self.search.text, "formId":dataInfo["Id"]],
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

    @IBAction func didPressSearch() {
        
        self.view.endEditing(true)
        
        didRequest()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
}

extension QL_Search_ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
//        let indexing = Int(textField.accessibilityLabel!)
        
//        if let text = textField.text as NSString? {
//            let txtAfterUpdate = text.replacingCharacters(in: range, with: string)
//
////            (dataList[indexing!] as! NSMutableDictionary)["data"] = txtAfterUpdate
//        }
        
        return true
    }
}


extension QL_Search_ViewController: UITableViewDataSource, UITableViewDelegate {
    
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
        
//        (self.withView(cell, tag: 104) as! UIImageView).imageUrl(url: icon)
        
        (self.withView(cell, tag: 104) as! UIImageView).image = UIImage(named: "ic_fire")
        
        (self.withView(cell, tag: 101) as! UILabel).text = "Mã %@ - %@".format(parameters: data.getValueFromKey(tagName["codeField"] as! String), data.getValueFromKey(tagName["labelField"] as! String))

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let data = dataList![indexPath.row] as! NSDictionary
        
        let currentCorr = self.latLng // Permission.shareInstance().currentLocation()! as NSDictionary

        let newForm = QL_Form_New_ViewController()

        newForm.detail = self.detail
        
        newForm.configType = ["title":(dataInfo["FormName"] as! String), "id":(dataInfo["Id"] as! NSNumber), "online":"", "coor": data.response(forKey: "lat") ? [["lat":data.getValueFromKey("lat"), "lng":data.getValueFromKey("lng")]] : [["lat":currentCorr.getValueFromKey("lat"), "lng":currentCorr.getValueFromKey("lng")]]]

        newForm.saveInfo = data
        
        self.present(newForm, animated: true) {

        }
    }
}


