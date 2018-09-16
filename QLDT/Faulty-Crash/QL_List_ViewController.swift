//
//  QL_List_ViewController.swift
//  QLDT
//
//  Created by Thanh Hai Tran on 9/11/18.
//  Copyright © 2018 Thanh Hai Tran. All rights reserved.
//

import UIKit

class QL_List_ViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var titleLabel: UILabel!
    
    var dataList: NSMutableArray!
    
    var configType: NSDictionary!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        titleLabel.text = configType.getValueFromKey("title")
        
        tableView.withCell("TG_List_Cell")
        
        dataList = NSMutableArray()
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
        self.navigationController?.popViewController(animated: true)
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
                        break
                    case 1:
                        let crash = QL_Crash_ViewController()
                        
                        crash.configType = self.configType
                        
                        crash.entityId = data.id
                        
                        crash.delegate = self
                        
                        self.present(crash, animated: true) {
                            
                        }
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
