//
//  QL_Home_ViewController.swift
//  QLDT
//
//  Created by Thanh Hai Tran on 7/29/18.
//  Copyright © 2018 Thanh Hai Tran. All rights reserved.
//

import UIKit

       
class QL_Home_ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet var collectionView: UICollectionView!
    
    var timer: Timer?

    var images: NSMutableArray? = ["","",""]
    
    let menuList: NSArray = [["title":"Đồng bộ danh mục", "ima":"ic_pass"], ["title":"Thay đổi địa chỉ máy chủ", "ima":"ic_pass"], ["title":"Thay đổi mật khẩu", "ima":"ic_pass"], ["title":"Cài đặt", "ima":"ic_pass"], ["title":"Đăng xuất", "ima":"ic_pass"], ["title":"Thoát", "ima":"ic_pass"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.withCell("TG_Image_Cell")
        
        syncing()
    }
    
    func syncing() {
        if LayerList.getAllData().count == 0 {
            self.showSVHUD("Đang cập nhật thông tin từ trang chủ", andOption: 0)
            
            startTimer()
        }
        
        didRequestAllField()
        
        didRequestLayerList()
        
        didRequestCommune()
        
        didRequestDistrict()
    }
    
    func startTimer() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
        timer = Timer.scheduledTimer(timeInterval: 3.0,
                                     target: self,
                                     selector: #selector(eventWith(timer:)),
                                     userInfo: nil,
                                     repeats: false)
    }
    
    @objc func eventWith(timer: Timer!) {
        self.hideSVHUD()
    }

    
    func didRequestLayerList() {
        if LayerList.getAllData().count != 0 {
            return
        }
        
        LTRequest.sharedInstance().didRequestInfo(["absoluteLink":"".urlGet(postFix: "api/LayerGroup/list"),
                                                   "header":["Authorization":Information.token == nil ? "" : Information.token!],
                                                   "method":"GET",
                                                   "overrideAlert":"1"], withCache: { (cache) in
                                                    
        }) { (response, errorCode, error, isValid) in
                        
            if errorCode != "200" {
                self.showToast("Lỗi xảy ra, mời bạn thử lại", andPos: 0)
                
                return
            }
            
            for layer in (response?.dictionize()["array"] as! NSArray) {
                let layerId = (layer as! NSDictionary)["Id"]
                
                let layerData = (layer as! NSDictionary).bv_jsonString(withPrettyPrint: true)
                
                LayerList.insertData(layerId: layerId as! Int32, layerData: layerData!)
            }
        }
    }
    
    func didRequestAllField() {
        if LayerField.getAllData().count != 0 {
            return
        }
        
        LTRequest.sharedInstance().didRequestInfo(["absoluteLink":"".urlGet(postFix: "api/Layer/getAllWithField"),
                                                   "header":["Authorization":Information.token == nil ? "" : Information.token!],
                                                   "method":"GET",
                                                   "overrideAlert":"1"], withCache: { (cache) in
                                                    
        }) { (response, errorCode, error, isValid) in
            
            if errorCode != "200" {
                self.showToast("Lỗi xảy ra, mời bạn thử lại", andPos: 0)
                
                return
            }
            
            for layer in (response?.dictionize()["array"] as! NSArray) {
                let layerId = (layer as! NSDictionary)["LayerId"]
                
                let layerData = (layer as! NSDictionary).bv_jsonString(withPrettyPrint: true)
                
                LayerField.insertData(layerId: layerId as! Int32, layerData: layerData!)
            }
        }
    }
    
    func didRequestCommune() {
        if CommuneField.getAllData().count != 0 {
            return
        }
        
        LTRequest.sharedInstance().didRequestInfo(["absoluteLink":"".urlGet(postFix: "api/Region/listCommune"),
                                                   "header":["Authorization":Information.token == nil ? "" : Information.token!],
                                                   "method":"GET",
                                                   "overrideAlert":"1"], withCache: { (cache) in
                                                    
        }) { (response, errorCode, error, isValid) in
            
            if errorCode != "200" {
                self.showToast("Lỗi xảy ra, mời bạn thử lại", andPos: 0)
                
                return
            }
            
            for layer in (response?.dictionize()["array"] as! NSArray) {
                let communeId = (layer as! NSDictionary)["area_id"]
                
                let communeData = (layer as! NSDictionary).bv_jsonString(withPrettyPrint: true)
                
                CommuneField.insertData(layerId: communeId as! Int32, layerData: communeData!)
            }
        }
    }
    
    func didRequestDistrict() {
        if DistrictField.getAllData().count != 0 {
            return
        }
        
        LTRequest.sharedInstance().didRequestInfo(["absoluteLink":"".urlGet(postFix: "api/Region/listDistrict"),
                                                   "header":["Authorization":Information.token == nil ? "" : Information.token!],
                                                   "method":"GET",
                                                   "overrideAlert":"1"], withCache: { (cache) in
                                                    
        }) { (response, errorCode, error, isValid) in
            
            if errorCode != "200" {
                self.showToast("Lỗi xảy ra, mời bạn thử lại", andPos: 0)
                
                return
            }
            
            for layer in (response?.dictionize()["array"] as! NSArray) {
                let districtId = (layer as! NSDictionary)["area_id"]
                
                let districtData = (layer as! NSDictionary).bv_jsonString(withPrettyPrint: true)
                
                DistrictField.insertData(layerId: districtId as! Int32, layerData: districtData!)
            }
        }
    }
    
    @IBAction func didPressMenu(menu: DropButton) {
        menu.didDropDown(withData: menuList as! [Any], andInfo: ["rect":CGRect.init(x: Int(self.screenWidth() - 225), y: -135, width: 225, height: 200)]) { (objc) in
            
            let indexing = (objc as! NSDictionary)["index"]
            
            switch (indexing as AnyObject).integerValue {
            case 0:
                LayerField.deleteAllData()
                LayerList.deleteAllData()
                CommuneField.deleteAllData()
                DistrictField.deleteAllData()
                self.syncing()
                break
            case 1:
                self.navigationController?.pushViewController(TL_ChangeHost_ViewController(), animated: true)
                break
            case 2:
                self.navigationController?.pushViewController(QL_Recover_ViewController(), animated: true)
                break
            case 3:
                self.navigationController?.pushViewController(QL_Setting_ViewController(), animated: true)
                break
            case 4:
                self.navigationController?.popToRootViewController(animated: true)
                break
            case 5:
                exit(0)
                break
            default :
                break
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Int(screenWidth()/2 + 50), height: Int(screenWidth()/2 + 50))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TG_Image_Cell", for: indexPath as IndexPath)
        
        let image = (self.withView(cell, tag: 11) as! UIImageView)
        
        image.withBorder(["Bcorner":3, "Bwidth":0.5, "Bhex":"#147EFB"])
        
        image.imageUrl(url: images![indexPath.item] as! String)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(QL_Info_Collector_ViewController(), animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
