//
//  QL_Info_Collector_ViewController.swift
//  QLDT
//
//  Created by Thanh Hai Tran on 9/6/18.
//  Copyright © 2018 Thanh Hai Tran. All rights reserved.
//

import UIKit

class QL_Info_Collector_ViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var titleLabel: UILabel!
 
    var type: Int!
    
    var dataList: NSMutableArray!
    
    var images: NSMutableArray? = [["title":"Đường bộ", "img":"ic_2"],["title":"Đường thủy", "img":"ic_3"],["title":"Đường sắt", "img":"ic_4"],["title":"Biểu mẫu", "img":"ic_5"]]
    
    var images1: NSMutableArray? = [["title":"Tai nạn", "img":"ic_acc", "type":0, "id":1032],["title":"Sự cố", "img":"ic_report", "type":1, "id":20],["title":"Phản hồi", "img":"ic_speaker", "type":2, "id":14]]
    
    var images2: NSMutableArray? = [["title":"Kiểm tra", "img":"ic_888", "url":"api/Maintain/listInspection"],["title":"Bảo trì", "img":"ic_999", "url":"api/Maintain/listMaintenance"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = type == 0 ? "Thu thập dữ liệu" : type == 1 ? "Sự cố" : "Kiểm tả - bảo trì"
        
        dataList = type == 0 ? images : type == 1 ? images1 : images2
        
        tableView.withCell("TG_Cell")
    }

    @IBAction func didPressBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension QL_Info_Collector_ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TG_Cell", for: indexPath)
        
        let data = dataList![indexPath.row] as! NSDictionary
        
        (self.withView(cell, tag: 104) as! UIImageView).image = UIImage.init(named: (data["img"] as? String)!)
        
        (self.withView(cell, tag: 101) as! UILabel).text = "  %@".format(parameters: (data["title"] as? String)!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let data = dataList![indexPath.row] as! NSDictionary

        let configData = NSMutableDictionary()
        
        configData.addEntries(from: data as! [AnyHashable : Any])
        
        if type == 1 {
            let list = QL_List_ViewController()
            
            list.configType = configData
            
            self.navigationController?.pushViewController(list, animated: true)
        }

        if type == 2 {
            let commonList = QL_Common_List_ViewController()
            
            commonList.configType = configData
            
            self.navigationController?.pushViewController(commonList, animated: true)
        }
    }
}

