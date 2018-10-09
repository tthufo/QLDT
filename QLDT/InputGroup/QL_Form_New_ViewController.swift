//
//  QL_Form_New_ViewController.swift
//  QLDT
//
//  Created by Thanh Hai Tran on 10/4/18.
//  Copyright © 2018 Thanh Hai Tran. All rights reserved.
//

import UIKit

import AVHexColor

class QL_Form_New_ViewController: ViewPagerController {

    var controllers: NSMutableArray!

    var titles = ["Cập nhật", "Bản đồ hướng dẫn"]

    var dataInfo: NSDictionary!
    
    var saveInfo: NSDictionary!
    
    var detail: NSDictionary!
    
    var configType: NSDictionary!
    
    @IBOutlet var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.titleLabel.text = self.configType.response(forKey: "title") ? self.configType["title"] as! String : self.configType.response(forKey: "FormName") ? self.configType["FormName"] as! String : "QLGTVT Bắc Ninh"
        
        self.dataSource = self
        
        self.delegate = self
        
        self.topHeight = iOS_VERSION_GREATER_THAN(version: "11") ? "64" : "64"
        
        controllers = NSMutableArray()
        
        
        
        
        
        let form = QL_Crash_ViewController()
        
        form.saveInfo = self.saveInfo
        
        form.configType = self.configType
                
        form.isHide = true
        
        controllers.add(form)
        
        
        
        
        let type = ((detail as NSDictionary)["Layer"] as! NSDictionary)["ShapeType"] as! String
        
        
        
        let map = QL_Map_ViewController()
                
        map.tempLocation = self.saveInfo == nil ? [] : (type == "Point" ? [["lat":self.saveInfo.getValueFromKey("lat"), "lng":self.saveInfo.getValueFromKey("lng")]] : self.revertGeoText(geoText: self.saveInfo.getValueFromKey("geom_text"))) as! [[String : String]]
        
        map.isMulti = type == "Point" ? false : true
        
        map.mutliType = type
        
        map.isForShow = true
                
        controllers.add(map)
    }

    func revertGeoText(geoText: String) -> NSArray {
        
        var text = geoText.replacingOccurrences(of: "LINESTRING", with: "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
        
        text.removeFirst()
        
        let array = NSMutableArray()
        
        for coor in text.components(separatedBy: ", ") {
            
            let coors = coor.components(separatedBy: " ")
            
            array.add(["lat":coors[1], "lng":coors[0]])
        }
        
        return array
    }
    
    func moveToMap() {
        self.selectTab(at: 1)
    }
    
    @IBAction func didPressBack() {
        self.dismiss(animated: true, completion: nil)
        
        (self.controllers.lastObject as! QL_Map_ViewController).endTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        (self.controllers.lastObject as! QL_Map_ViewController).endTimer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func modelLabel(index: Int) -> UILabel {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.text = titles[index]
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.sizeToFit()
        return label
    }
}

extension QL_Form_New_ViewController: ViewPagerDelegate, ViewPagerDataSource {
    func numberOfTabs(forViewPager viewPager: ViewPagerController!) -> UInt {
        return UInt(titles.count)
    }
    
    func viewPager(_ viewPager: ViewPagerController!, viewForTabAt index: UInt) -> UIView! {
        return modelLabel(index: Int(index))
    }
    
    func viewPager(_ viewPager: ViewPagerController!, contentViewControllerForTabAt index: UInt) -> UIViewController! {
        return controllers[Int(index)] as! UIViewController
    }
    
    func viewPager(_ viewPager: ViewPagerController!, didChangeTabTo index: UInt) {
        for view in viewPager.tabsView.subviews {
            for tab in view.subviews {
                if (tab as AnyObject).isKind(of: UILabel.self) {
                    (tab as! UILabel).textColor = (viewPager.tabsView.subviews.index(of: view) as! Int) != index ? UIColor.lightGray : UIColor.orange
                }
            }
        }
    }
    
    func viewPager(_ viewPager: ViewPagerController!, valueFor option: ViewPagerOption, withDefault value: CGFloat) -> CGFloat {
        
        if option == .tabWidth {
            return CGFloat((Int(self.screenWidth()) / titles.count))
        } else if option == .tabHeight {
            return 35
        } else if option == .tabLocation {
            return 1
        }
        
        return value
    }
    
    func viewPager(_ viewPager: ViewPagerController!, colorFor component: ViewPagerComponent, withDefault color: UIColor!) -> UIColor! {
        
        if component == .indicator {
            return UIColor.orange
        } else if component == .tabsView {
            return UIColor.clear
        } else if component == .content {
            return UIColor.lightGray
        }
        
        return color
    }
}
