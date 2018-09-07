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
    
    @IBOutlet var bar: UIView!
    
    @IBOutlet var chat: UIButton!
    
    var dataList: NSMutableArray!
    
    var checkUpData: NSDictionary!
    
    var kb: KeyBoard!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.withCell("QL_Check_Cell")

        dataList = NSMutableArray()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "QL_Check_Cell", for: indexPath)
        
        if dataList.count == 0 {
            return cell
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}

