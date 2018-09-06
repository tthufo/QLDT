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
    
    var dataList: NSMutableArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.withCell("TG_Drop_Cell")
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
        return 44
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LayerList.getAllData().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TG_Drop_Cell", for: indexPath)
        
        let layer = LayerList.getAllData()[indexPath.row] as! Layer
        
        let data = layer.layerData?.dictionize()
        
        (self.withView(cell, tag: 104) as! UIImageView).imageUrl(url: data!["Icon"] as! String)
        
        (self.withView(cell, tag: 101) as! UILabel).text = "  %@".format(parameters: (data!["ModuleName"] as? String)!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
//        let hotel = dataList[indexPath.row] as! NSDictionary
//
//        let detail = TG_Hotel_Detail_ViewController()
//
//        detail.detailInfo = ["hotelId":hotel.getValueFromKey("id")]
//
//        self.navigationController?.pushViewController(detail, animated: true)
    }
}

