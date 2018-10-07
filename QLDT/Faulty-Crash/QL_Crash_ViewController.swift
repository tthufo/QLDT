//
//  QL_Crash_ViewController.swift
//  QLDT
//
//  Created by Thanh Hai Tran on 9/11/18.
//  Copyright © 2018 Thanh Hai Tran. All rights reserved.
//

import UIKit

protocol EditDelegate:class {
    func editDidReloadData(data: NSDictionary)
}

class QL_Crash_ViewController: UIViewController {

    weak var delegate: EditDelegate?

    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var titleLabel: UILabel!
    
    var dataList: NSMutableArray!
    
    var configType: NSDictionary!
    
    var saveInfo: NSDictionary!
    
    var dataTemp: NSMutableDictionary!
    
    @IBOutlet var layout: NSLayoutConstraint!
    
    var isHide: Bool = false
    
    var kb: KeyBoard!
    
    var entityId: Int32 = -1
    
    var updateUrl: String = ""
    
    func prepareData() {
        
        if self.dataTemp == nil {
            return
        }
        
        for dict in self.dataTemp!["LayerFields"] as! NSMutableArray {
            let tempo = dict as! NSMutableDictionary
            
            (dict as! NSMutableDictionary)["data"] = ""
            
            if tempo.getValueFromKey("FieldOrder") == "999" {
                if tempo.getValueFromKey("FieldName") == "anh_minh_hoa" {
                    (dict as! NSMutableDictionary)["ident"] = "QL_Image_Cell"
                }
            } else {
                if tempo.getValueFromKey("FieldType") == "nvarchar" || tempo.getValueFromKey("FieldType") == "varchar" {
                    (dict as! NSMutableDictionary)["ident"] = "QL_Input_Cell"
                }
                
                if !(tempo["CategoryType"] as AnyObject).isKind(of: NSString.self) {
                    (dict as! NSMutableDictionary)["ident"] = "QL_Drop_Cell"
                    let data = (tempo["CategoryType"] as! NSDictionary)["Categories"]
                    (dict as! NSMutableDictionary)["data"] = data
                    (dict as! NSMutableDictionary)["pList"] = "drop"
                    (dict as! NSMutableDictionary)["key"] = "ItemName"
                    (dict as! NSMutableDictionary)["activeData"] = (data as! NSArray).count != 0 ? (data as! NSArray).firstObject :
                        ["ItemCode": "",
                         "ItemName": "Dữ liệu trống",
                         "Style": "",
                         "CategoryTypeId": -1]
                    (dict as! NSMutableDictionary)["color"] = (data as! NSArray).count != 0 ? "black" : "red"
                }
                
                if tempo.getValueFromKey("FieldType") == "int" {
                    if tempo.getValueFromKey("FieldName") == "xa_id" {
                        (dict as! NSMutableDictionary)["ident"] = "QL_Drop_Cell"
                        let data = Commune.getAllData()
                        (dict as! NSMutableDictionary)["data"] = data
                        (dict as! NSMutableDictionary)["pList"] = "region"
                        (dict as! NSMutableDictionary)["key"] = "region_name"
                        (dict as! NSMutableDictionary)["activeData"] = (data as NSArray).firstObject
                    } else if tempo.getValueFromKey("FieldName") == "huyen_id" {
                        (dict as! NSMutableDictionary)["ident"] = "QL_Drop_Cell"
                        let data = District.getAllData()
                        (dict as! NSMutableDictionary)["data"] = data
                        (dict as! NSMutableDictionary)["pList"] = "region"
                        (dict as! NSMutableDictionary)["key"] = "region_name"
                        (dict as! NSMutableDictionary)["activeData"] = (data as NSArray).firstObject
                    } else {
                        (dict as! NSMutableDictionary)["ident"] = "QL_Input_Cell"
                        (dict as! NSMutableDictionary)["number"] = "number"
                    }
                }
                
                if tempo.getValueFromKey("FieldType") == "float" || tempo.getValueFromKey("FieldType") == "smallint" || tempo.getValueFromKey("FieldType") == "decimal" {
                    (dict as! NSMutableDictionary)["ident"] = "QL_Input_Cell"
                    (dict as! NSMutableDictionary)["number"] = "number"
                }
                
                if tempo.getValueFromKey("FieldType") == "datetime" || tempo.getValueFromKey("FieldType") == "datetime1" || tempo.getValueFromKey("FieldType") == "datetime2"{
                    (dict as! NSMutableDictionary)["ident"] = "QL_Calendar_Cell"
                }
                
                if tempo.getValueFromKey("FieldName") == "geom_text" {
                    (dict as! NSMutableDictionary)["ident"] = "QL_Geo_Cell"
                    (dict as! NSMutableDictionary)["data"] = []
                }
                
                if tempo.getValueFromKey("FieldType") == "numeric" || tempo.getValueFromKey("FieldType") == "decimal" {
                    if tempo.getValueFromKey("FieldName") != "lat" && tempo.getValueFromKey("FieldName") != "lng" {
                        (dict as! NSMutableDictionary)["ident"] = "QL_Input_Cell"
                        (dict as! NSMutableDictionary)["number"] = "number"
                    }
                    
                    
                    if tempo.getValueFromKey("FieldName") == "lat" {
                        (dict as! NSMutableDictionary)["ident"] = "QL_Location_Cell"
                        (dict as! NSMutableDictionary)["FieldLabel"] = "Tọa độ"
                        (dict as! NSMutableDictionary)["data"] = []
                    }
                    
                    if tempo.getValueFromKey("FieldName") == "lng" {
                        (dict as! NSMutableDictionary)["ident"] = "QL_Location_Cell"
                        (dict as! NSMutableDictionary)["IsVisible"] = false
                        (dict as! NSMutableDictionary)["data"] = []
                    }
                }
            }
        }
    }
    
    func dataFormat() -> NSMutableArray {
        
        let ID = self.configType["id"]
        
        if entityId  == -1 {
            self.dataTemp = (Field.getData(layerId: ID as! Int32).first)
        } else {
            self.dataTemp = (Temp.getData(id: entityId, parentId: ID as! Int32).first)
            
            self.updateUrl = self.dataTemp["MobileCreateURL"] as! String
            
            self.updateUrl.removeLast()
            
            self.updateUrl.removeFirst()
            
            return self.dataTemp!["LayerFields"] as! NSMutableArray
        }
        
        prepareData()
        
        self.updateUrl = self.dataTemp != nil ? self.dataTemp["MobileCreateURL"] as! String : "   "
        
        self.updateUrl.removeLast()
        
        self.updateUrl.removeFirst()
        
        return self.dataTemp != nil ? self.dataTemp!["LayerFields"] as! NSMutableArray : []
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kb = KeyBoard.shareInstance()
        
        if isHide {
            layout.constant = 0
        }
        
        titleLabel.text = configType.getValueFromKey("title")
        
        tableView.withCell("QL_Input_Cell")
        
        tableView.withCell("QL_Drop_Cell")
        
        tableView.withCell("QL_Calendar_Cell")

        tableView.withCell("QL_Location_Cell")

        tableView.withCell("QL_Geo_Cell")

        tableView.withCell("QL_Image_Cell")

        
        dataList = NSMutableArray()
        
        if self.configType.response(forKey: "online") {
            didRequestDetail()
        } else {
            dataList.addObjects(from: dataFormat() as! [Any])
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
    
    func didRequestDetail() {
        LTRequest.sharedInstance().didRequestInfo(["absoluteLink":"".urlGet(postFix: "api/Form/detail"),
                                                   "header":["Authorization":Information.token == nil ? "" : Information.token!],
                                                   "method":"GET",
                                                   "Getparam":["id":self.configType["id"]],
                                                   "overrideLoading":1,
                                                   "overrideAlert":1,
                                                   "host":self
            ], withCache: { (cache) in
                
        }) { (response, errorCode, error, isValid) in
            
            if errorCode != "200" {
                self.showToast("Lỗi xảy ra, mời bạn thử lại", andPos: 0)
                
                return
            }
            
            let result = (response?.dictionize()["FormFields"] as! NSArray)
            
            self.updateUrl = ((response?.dictionize()["Layer"] as! NSDictionary)["MobileCreateURL"] as! String)
            
            self.updateUrl.removeLast()
            
            self.updateUrl.removeFirst()

            
            let tempArray = NSMutableArray()
            
            for dict in result {
                tempArray.add(((dict as! NSDictionary)["LayerField"] as! NSDictionary).reFormat())
            }
            
            self.dataTemp = ["LayerFields":tempArray]
            
            self.prepareData()
            
            if self.saveInfo != nil {
                self.reFormatData()
            }
            
            self.dataList.addObjects(from: self.dataTemp!["LayerFields"] as! [Any])

            self.tableView.reloadData()
        }
    }
    
    func reFormatData() {
        for key in self.saveInfo.allKeys {
            for dict in self.dataTemp["LayerFields"] as! NSArray {
                if ((dict as! NSDictionary)["FieldName"] as! String) == (key as! String) {
                    if ((dict as! NSDictionary)["CategoryType"] as AnyObject).isKind(of: NSString.self) {
                        if (dict as! NSDictionary)["FieldName"] as! String == "lat" || (dict as! NSDictionary)["FieldName"] as! String == "lng" {
                            (dict as! NSMutableDictionary)["data"] = [["lat":self.saveInfo.getValueFromKey("lat"), "lng":self.saveInfo.getValueFromKey("lng")]]
                        } else {
                            (dict as! NSMutableDictionary)["data"] = self.saveInfo.getValueFromKey(key as! String)
                        }
                        
                        if ((dict as! NSDictionary)["FieldName"] as! String) == "xa_id" {
                            let data = Commune.getAllData()
                            for commune in data {
                                if commune.getValueFromKey("area_id") == self.saveInfo.getValueFromKey(key as! String) {
                                    (dict as! NSMutableDictionary)["activeData"] = commune
                                }
                            }
                            (dict as! NSMutableDictionary)["data"] = data
                        }
                        
                        if ((dict as! NSDictionary)["FieldName"] as! String) == "huyen_id" {
                            let data = District.getAllData()
                            for district in data {
                                if district.getValueFromKey("area_id") == self.saveInfo.getValueFromKey(key as! String) {
                                    (dict as! NSMutableDictionary)["activeData"] = district
                                }
                            }
                            (dict as! NSMutableDictionary)["data"] = data
                        }
                        
                    } else {
                        let data = ((dict as! NSDictionary)["CategoryType"] as! NSDictionary)["Categories"] as! NSArray
                        for inner in data {
                            if (inner as! NSDictionary)["ItemCode"] as! String == self.saveInfo[key] as! String {
                                (dict as! NSMutableDictionary)["activeData"] = data.count != 0 ? inner :
                                ["ItemCode": "",
                                "ItemName": "Dữ liệu trống",
                                "Style": "",
                                "CategoryTypeId": -1]
                            }
                        }
                    }
                }
            }
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
    
    func didRequestUpdate(postData: NSDictionary) {
        (CustomField.shareText() as! CustomField).requesting("".urlGet(postFix: self.updateUrl), andInfo: postData as! [AnyHashable : Any], andCompletion: { (done, respond) in
            
            if done {
                if self.entityId != -1 {
                    let ID = self.configType["id"]

                    Temp.deleteData(id: self.entityId, parentId: ID as! Int32)
                }
                
                self.navigationController?.popViewController(animated: true)
                
                self.showToast("Cập nhật thành công", andPos: 0)

                self.dismiss(animated: true, completion: {
                })
            } else {
                self.showToast("Lỗi xảy ra, mời bạn thử lại", andPos: 0)
            }
        })
    }
    
    var titleString = "Thông tin trống./"
    
    func checkValid() -> Bool {
        
        var isValid = true
        
        let data = self.dataTemp!["LayerFields"] as! NSMutableArray
        
        for dict in data {
            if (dict as! NSDictionary)["Require"] as! Bool {
                if ((dict as! NSDictionary)["data"] as AnyObject).isKind(of: NSString.self) {
                    if (dict as! NSDictionary).getValueFromKey("data") == "" {
                        self.showToast("Bạn nhập đủ thông tin %@".format(parameters: (dict as! NSDictionary)["FieldLabel"] as! String) , andPos: 0)
                        
                        isValid = false
                        
                        break
                    } else {
                        titleString = (dict as! NSDictionary).getValueFromKey("data")
                    }
                }
            }
        }
        
        return isValid
    }
    
    @IBAction func didPressList() {
        let list = QL_List_ViewController()

        list.configType = self.configType

        list.delegate = self
//        self.navigationController?.pushViewController(list, animated: true)
        
        self.present(list, animated: true) {
            
        }
    }
    
    @IBAction func didRequestSubmit() {
        
        if self.configType.response(forKey: "online") {
            if checkValid() {
                let postData = NSMutableDictionary()
                
                for dict in self.dataList {
                    if (dict as! NSDictionary)["IsVisible"] as! Bool {
                        
                        let key = (dict as! NSDictionary)["FieldName"] ?? ""
                        
                        if (dict as! NSDictionary).response(forKey: "activeData") {
                            if key as! String == "huyen_id" || key as! String == "xa_id" {
                                postData[key] = ((dict as! NSDictionary)["activeData"] as! NSDictionary)["area_id"]
                            } else {
                                postData[key] = ((dict as! NSDictionary)["activeData"] as! NSDictionary)["ItemCode"]
                            }
                        }
                        
                        if ((dict as! NSDictionary)["data"] as AnyObject).isKind(of: NSArray.self) {
                            if ((dict as! NSDictionary)["data"] as! NSArray).count != 0 {
                                if ((dict as! NSDictionary)["data"] as! NSArray).count == 1 {
                                    if key as! String == "lat" || key as! String == "lng" {
                                        let latLng = ((dict as! NSDictionary)["data"] as! NSArray).firstObject as! NSDictionary
                                        
                                        postData["lat"] = latLng["lat"]
                                        
                                        postData["lng"] = latLng["lng"]
                                    }
                                } else {
                                    if key as! String == "geom_text" {
                                        var tempString = "LINESTRING ("
                                        
                                        for inner in ((dict as! NSDictionary)["data"] as! NSArray) {
                                            tempString.append(((inner as! NSDictionary)["lat"] as! String) + " " + ((inner as! NSDictionary)["lng"] as! String) + ",")
                                        }
                                        
                                        tempString.removeLast()
                                        
                                        tempString.append(")")
                                        
                                        postData[key] = tempString
                                    }
                                }
                            }
                        } else {
                            if ((dict as! NSDictionary)["data"] as! String) != "" {
                                postData[key] = ((dict as! NSDictionary)["data"] as! String)
                            }
                        }
                    }
                }
                
                didRequestUpdate(postData: postData)
            }
        } else {
            if LTRequest.isConnectionAvailable() {
                if checkValid() {
                    DropAlert.shareInstance().alert(withInfor: ["title":"Thông báo", "buttons":["Lưu lại"], "cancel":"Cập nhật", "message":"Mạng đang khả dụng. Bạn có muốn cập nhật dữ liệu ?"], andCompletion: { (index, result) in
                        if index != 0 {
                            
                            let postData = NSMutableDictionary()
                            
                            for dict in self.dataList {
                                if (dict as! NSDictionary)["IsVisible"] as! Bool {
                                    
                                    let key = (dict as! NSDictionary)["FieldName"] ?? ""
                                    
                                    if (dict as! NSDictionary).response(forKey: "activeData") {
                                        if key as! String == "huyen_id" || key as! String == "xa_id" {
                                            postData[key] = ((dict as! NSDictionary)["activeData"] as! NSDictionary)["area_id"]
                                        } else {
                                            postData[key] = ((dict as! NSDictionary)["activeData"] as! NSDictionary)["ItemCode"]
                                        }
                                    }
                                    
                                    if ((dict as! NSDictionary)["data"] as AnyObject).isKind(of: NSArray.self) {
                                        if ((dict as! NSDictionary)["data"] as! NSArray).count != 0 {
                                            if ((dict as! NSDictionary)["data"] as! NSArray).count == 1 {
                                                if key as! String == "lat" || key as! String == "lng" {
                                                    let latLng = ((dict as! NSDictionary)["data"] as! NSArray).firstObject as! NSDictionary
                                                    
                                                    postData["lat"] = latLng["lat"]
                                                    
                                                    postData["lng"] = latLng["lng"]
                                                }
                                            } else {
                                                if key as! String == "geom_text" {
                                                    var tempString = "LINESTRING ("
                                                    
                                                    for inner in ((dict as! NSDictionary)["data"] as! NSArray) {
                                                        tempString.append(((inner as! NSDictionary)["lat"] as! String) + " " + ((inner as! NSDictionary)["lng"] as! String) + ",")
                                                    }
                                                    
                                                    tempString.removeLast()
                                                    
                                                    tempString.append(")")
                                                    
                                                    postData[key] = tempString
                                                }
                                            }
                                        }
                                    } else {
                                        if ((dict as! NSDictionary)["data"] as! String) != "" {
                                            postData[key] = ((dict as! NSDictionary)["data"] as! String)
                                        }
                                    }
                                }
                            }
                                                        
                            self.didRequestUpdate(postData: postData)

                        } else {
                            self.didSyncData()
                        }
                    })
                }
                
            } else {
                self.didSyncData()
            }
        }
    }
    
    func didSyncData() {
        if entityId == -1 {
            Temp.insertData(parentId: self.configType["id"] as! Int32, tempData: self.dataTemp.bv_jsonString(withPrettyPrint: true), title: self.titleString, date: self.currentDate("yyyy-MM-dd HH:ss"))
        } else {
            Temp.modifyData(id: entityId, parentId: configType["id"] as! Int32, title: self.titleString, tempData: self.dataTemp.bv_jsonString(withPrettyPrint: true), date: self.currentDate("yyyy-MM-dd HH:ss"))
        }
        
        didPressBack()
    }
    
    @IBAction func didPressBack() {
        self.navigationController?.popViewController(animated: true)
        
        self.dismiss(animated: true) {
            
        }
    }
    
    func didAskForMedia(indexing: String) {
        Permission.shareInstance().askGallery { (camType) in
            switch (camType) {
            case .authorized:
                Media.shareInstance().startPickImage(withOption: false, andBase: nil, andRoot: self, andCompletion: { (image) in
                    if image != nil {
                        self.saveImage(image: image as! UIImage, indexing: indexing)
                    }
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
                    if image != nil {
                        self.saveImage(image: image as! UIImage, indexing: indexing)
                    }
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
                    if image != nil {
                        self.saveImage(image: image as! UIImage, indexing: indexing)
                    }
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
                    if image != nil {
                        self.saveImage(image: image as! UIImage, indexing: indexing)
                    }
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
    
    func geoText(data: NSArray) -> String {
        
        var geo = ""
        
        for i in stride(from: 0, to: data.count, by: 1) {
            geo.append("(X%i: %@ Y%i: %@); ".format(parameters:i + 1, (data[i] as! NSDictionary)["lat"] as! String, i + 1, (data[i] as! NSDictionary)["lng"] as! String))
        }
        
        return geo
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension QL_Crash_ViewController: ListDelegate {
    func listDidReloadData(data: NSDictionary) {
        self.entityId = data["entityId"] as! Int32
        
        self.dataList.removeAllObjects()
        
        dataList.addObjects(from: dataFormat() as! [Any])
        
        self.tableView.reloadData()
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
        let data = dataList![indexPath.row] as! NSDictionary

        let isShow = data["IsVisible"] as! Bool
        
        return isShow ? UITableViewAutomaticDimension : 0
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

        (self.withView(cell, tag: 1) as! UILabel).text = data["FieldLabel"] as? String

        let isRequired = data["Require"] as! Bool

        (self.withView(cell, tag: 1) as! UILabel).textColor = isRequired ? UIColor.red : UIColor.black
        
        
        if data["ident"] as! String == "QL_Input_Cell" {
            let input = (self.withView(cell, tag: 2) as! UITextField)
            
            let isNumber = data.response(forKey: "number")
            
            input.keyboardType = isNumber ? .numberPad : .default
            
            input.inputAccessoryView = isNumber ? self.toolBar() : nil
            
            input.accessibilityLabel = "%i".format(parameters: indexPath.row)
            
            input.delegate = self
            
            input.text = data["data"] as? String
        }
        
        if data["ident"] as! String == "QL_Drop_Cell" {
            
//            if !(data["activeData"] as AnyObject).isKind(of: NSDictionary.self) {
//
//                (self.withView(cell, tag: 2) as! DropButton).setTitle("Dữ liệu trống", for: .normal)
//
//            } else {
            
                let activeData = data["activeData"] as! NSDictionary
                
                let plistName = data["pList"]
                
                let key = data["key"] as! String
                
                let drop = (self.withView(cell, tag: 2) as! DropButton)
                
                drop.pListName = plistName as! NSString
                
                drop.setTitle(activeData[key] as? String, for: .normal)
            
                drop.setTitleColor((data["color"] as? String) == "black" ? UIColor.black : UIColor.red , for: .normal)
            
                drop.action(forTouch: [:]) { (objc) in
                    
                    self.view.endEditing(true)
                    
                    drop.didDropDown(withData: data["data"] as! [Any], andCompletion: { (result) in
                        if result != nil {
                            let data = (result as! NSDictionary)["data"]
                            
                            (self.dataList![indexPath.row] as! NSMutableDictionary)["activeData"] = data
                            
                            drop.setTitle((data as! NSDictionary)[key] as? String, for: .normal)
                        }
                    })
//                }
            }
        }
        
        if data["ident"] as! String == "QL_Calendar_Cell" {
            let cal = (self.withView(cell, tag: 2) as! UIImageView)
            
            cal.action(forTouch: [:]) { (objc) in
                
                self.view.endEditing(true)

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
                
                if !Permission.shareInstance().isLocationEnable() {
                    
                    self.showToast("Truy cập vị trí không khả dụng", andPos: 0)
                    
                    return
                }
                
                self.view.endEditing(true)

                let map = QL_Map_ViewController()
                
                map.indexing = "%i".format(parameters: indexPath.row)
                
                map.tempLocation = data["data"] as! [[String : String]]

                map.isMulti = false

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
        
        if data["ident"] as! String == "QL_Geo_Cell" {
            let loc = (self.withView(cell, tag: 2) as! UIImageView)
            
            loc.action(forTouch: [:]) { (objc) in
                
                if !Permission.shareInstance().isLocationEnable() {
                    
                    self.showToast("Truy cập vị trí không khả dụng", andPos: 0)
                    
                    return
                }
                
                self.view.endEditing(true)

                let map = QL_Map_ViewController()
                
                map.indexing = "%i".format(parameters: indexPath.row)
                
                map.tempLocation = data["data"] as! [[String : String]] 
                
                map.isMulti = true
                
                map.delegate = self
                
                self.present(map, animated: true, completion: {
                    
                })
            }
            
            let te = (self.withView(cell, tag: 100) as! UILabel)

            let scroll = (self.withView(cell, tag: 200) as! UIScrollView)

            
            if (data["data"] as! NSArray).count != 0 {
                
                te.text = self.geoText(data: (data["data"] as? NSArray)!)

                scroll.contentSize = CGSize.init(width: te.getSize().width + 10, height: 44)
            }
        }
        
        if data["ident"] as! String == "QL_Image_Cell" {
            
            let gallery = (self.withView(cell, tag: 2) as! UIButton)
            
            gallery.action(forTouch: [:]) { (objc) in
                
                self.view.endEditing(true)

                self.didAskForMedia(indexing: "%i".format(parameters: indexPath.row))
            }
            
            let cam = (self.withView(cell, tag: 3) as! UIButton)
            
            cam.action(forTouch: [:]) { (objc) in
                
                self.view.endEditing(true)

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
