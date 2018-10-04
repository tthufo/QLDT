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
    
    var configType: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
        
        self.delegate = self
        
        self.topHeight = iOS_VERSION_GREATER_THAN(version: "11") ? "64" : "64"
        
        controllers = NSMutableArray()
        
        let form = QL_Crash_ViewController()
        
        form.configType = self.configType
        
        controllers.add(form)
        
        let map = QL_Map_ViewController()
        
        map.isMulti = false
        
        controllers.add(map)
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
                    (tab as! UILabel).textColor = (viewPager.tabsView.subviews.index(of: view) as! Int) != index ? UIColor.lightGray : AVHexColor.color(withHexString: "#1ec354")
                }
            }
        }
    }
    
    func viewPager(_ viewPager: ViewPagerController!, valueFor option: ViewPagerOption, withDefault value: CGFloat) -> CGFloat {
        
        if option == .tabWidth {
            return CGFloat((Int(self.screenWidth()) / titles.count) + 10)
        } else if option == .tabHeight {
            return 35
        } else if option == .tabLocation {
            return 1
        }
        
        return value
    }
    
    func viewPager(_ viewPager: ViewPagerController!, colorFor component: ViewPagerComponent, withDefault color: UIColor!) -> UIColor! {
        
        if component == .indicator {
            return UIColor.clear
        } else if component == .tabsView {
            return UIColor.clear
        } else if component == .content {
            return UIColor.lightGray
        }
        
        return color
    }
}
