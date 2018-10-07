//
//  QL_List_ViewController.swift
//  QLDT
//
//  Created by Thanh Hai Tran on 9/11/18.
//  Copyright © 2018 Thanh Hai Tran. All rights reserved.
//

import UIKit

protocol ListDelegate:class {
    func listDidReloadData(data: NSDictionary)
}

class QL_List_ViewController: UIViewController {

    weak var delegate: ListDelegate?

    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var titleLabel: UILabel!
    
    var dataList: NSMutableArray!
    
    var dataListPost: NSMutableArray!

    
    var configType: NSDictionary!
    
    var dataTemp: NSMutableDictionary!
    
    var updateUrl: String = ""
    
    func dataFormat(entityId: Int32) -> NSMutableArray {
        
        let ID = self.configType["id"]
        
        self.dataTemp = (Temp.getData(id: entityId, parentId: ID as! Int32).first)
        
        self.updateUrl = self.dataTemp["MobileCreateURL"] as! String
        
        self.updateUrl.removeLast()
        
        self.updateUrl.removeFirst()
        
        return self.dataTemp!["LayerFields"] as! NSMutableArray
    }
    
    func prepareData() {
        
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
                    (dict as! NSMutableDictionary)["color"] = (data as! NSArray).count != 0 ? UIColor.black : UIColor.red
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
                    }
                }
            }
        }
        
        return isValid
    }
    
    func didRequestUpdate(entityId: Int32) {
        if checkValid() {
            let postData = NSMutableDictionary()
            
            for dict in self.dataListPost {
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
            self.didRequestUpdate(postData: postData, entityId: entityId)
        }
    }
    
    func didRequestUpdate(postData: NSDictionary, entityId: Int32) {
        (CustomField.shareText() as! CustomField).requesting("".urlGet(postFix: self.updateUrl), andInfo: postData as! [AnyHashable : Any], andCompletion: { (done, respond) in
            
            if done {
                let ID = self.configType["id"]
                
                Temp.deleteData(id: entityId, parentId: ID as! Int32)
                
                self.getData()
                
                self.tableView.reloadData()
                
                self.showToast("Cập nhật thành công", andPos: 0)
            } else {
                self.showToast("Lỗi xảy ra, mời bạn thử lại", andPos: 0)
            }
        })
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        titleLabel.text = configType.getValueFromKey("title")
        
        tableView.withCell("TG_List_Cell")
        
        dataList = NSMutableArray()
        
        dataListPost = NSMutableArray()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
 
        getData()
    }
    
    func getData() {
        
        let arr = Temp.getDataTemp(parentId: configType["id"] as! Int32)
        
        dataList.removeAllObjects()
        
        dataList.addObjects(from: arr)
        
        self.tableView.reloadData()
    }
    
    @IBAction func didPressAdd() {
        let crash = QL_Crash_ViewController()

        crash.configType = self.configType

        crash.entityId = -1
        
        crash.delegate = self
        
        self.present(crash, animated: true) {
          
        }
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

extension QL_List_ViewController: EditDelegate {
    func editDidReloadData(data: NSDictionary) {

    }
}

extension QL_List_ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TG_List_Cell", for: indexPath)
        
        if dataList.count == 0 {
            return cell
        }
        
        let data = dataList![indexPath.row] as! TempData
                
        (self.withView(cell, tag: 104) as! UIImageView).image = UIImage(named: "ic_fire")

        (self.withView(cell, tag: 101) as! UILabel).text = "Mã: %@".format(parameters: data.title!)
        
        (self.withView(cell, tag: 102) as! UILabel).text = "Tạo: %@ - Sửa: %@".format(parameters: data.createDate!, data.modifyDate!)

        let drop = self.withView(cell, tag: 103) as! DropButton

        drop.action(forTouch: [:]) { (obj) in
            drop.didDropDown(withData: [["title":"Cập nhật"], ["title":"Sửa"], ["title":"Xóa"]] as [Any], andCompletion: { (result) in
                if result != nil {
                    
                    let indexing = (result as! NSDictionary)["index"]
                    
                    switch indexing as! Int {
                    case 0:
                        self.dataListPost.removeAllObjects()
                        
                        self.dataListPost.addObjects(from: self.dataFormat(entityId: data.id) as! [Any])
                        
                        self.didRequestUpdate(entityId: data.id)
                        break
                    case 1:
                        
                        self.delegate?.listDidReloadData(data: ["data":self.configType, "entityId": data.id])
                        
                        self.dismiss(animated: true, completion: {
                            
                        })
                        
//                        let crash = QL_Crash_ViewController()
//
//                        crash.configType = self.configType
//
//                        crash.entityId = data.id
//
//                        crash.delegate = self
//
//                        self.present(crash, animated: true) {
//
//                        }
                        break
                    case 2:
                        Temp.deleteData(id: data.id, parentId: self.configType["id"] as! Int32)
                        
                        self.getData()
                        break
                    default:
                        break
                    }
                }
            })
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if dataList.count == 0 {
            return
        }
        
//        let data = dataList![indexPath.row] as! TempData
//
//        let crash = QL_Crash_ViewController()
//
//        crash.configType = self.configType
//
//        crash.entityId = data.id
//
//        crash.delegate = self
//
//        self.present(crash, animated: true) {
//
//        }
    }
}
