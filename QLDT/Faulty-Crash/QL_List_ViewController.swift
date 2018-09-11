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
        
        tableView.withCell("TG_Cell")
        
        dataList = NSMutableArray()
    }
    
    @IBAction func didPressAdd() {
        let crash = QL_Crash_ViewController()

        crash.configType = self.configType

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

extension QL_List_ViewController: MNCalendarViewDelegate {

    func calendarView(_ calendarView: MNCalendarView!, didSelect date: Date!) {
        
    }
    
    func calendarView(_ calendarView: MNCalendarView!, shouldSelect date: Date!) -> Bool {
        
//        NSTimeInterval timeInterval = [date timeIntervalSinceDate:self.currentDate];
//
//        if (timeInterval > MN_WEEK && timeInterval < (MN_WEEK * 2)) {
//            return NO;
//        }
//
//        return YES;
        
        return true
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "TG_Cell", for: indexPath)
        
        if dataList.count == 0 {
            return cell
        }
        
        let data = dataList![indexPath.row] as! NSDictionary
                
        (self.withView(cell, tag: 101) as! UILabel).text = "  %@".format(parameters: (data["Name"] as? String)!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
