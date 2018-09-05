//
//  QL_Info_Collector_ViewController.swift
//  QLDT
//
//  Created by Thanh Hai Tran on 9/6/18.
//  Copyright © 2018 Thanh Hai Tran. All rights reserved.
//

import UIKit

class QL_Info_Collector_ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        print((LayerList.getAllData()[0] as! Layer).layerData)
    }

    @IBAction func didPressBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
