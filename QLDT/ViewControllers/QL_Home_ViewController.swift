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
    
    @IBOutlet var menu: UIButton!

    var timer: Timer?

    var images: NSMutableArray? = [["title":"Thu thập dữ liệu", "img":"ic_thuthap"],["title":"Sự cố và vi phạm", "img":"ic_suco"],["title":"Kiểm tra - bảo trì", "img":"ic_kiemtra"]]
    
    let menuList: NSArray = [["title":"Đồng bộ danh mục", "ima":"ic_sync_home"], ["title":"Thay đổi địa chỉ máy chủ", "ima":"ic_change_server"], ["title":"Thay đổi mật khẩu", "ima":"ic_change_pass"], ["title":"Cài đặt", "ima":"ic_setting"], ["title":"Đăng xuất", "ima":"ic_logout"], ["title":"Thoát", "ima":"ic_exit"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.withCell("TG_Image_Cell")
        
        menu.alpha = Information.check == "1" ? 1 : 0
        
        syncing()
    }
    
    func syncing() {
        if Layer.getAllData().count == 0 {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                self.showSVHUD("Đang cập nhật thông tin từ trang chủ", andOption: 0)
            })
            
//            startTimer()
        }
        
        didRequestAllField()
        
//        didRequestLayerList()
//
//        didRequestCommune()
//
//        didRequestDistrict()
    }
    
//    func startTimer() {
//        if timer != nil {
//            timer?.invalidate()
//            timer = nil
//        }
//        timer = Timer.scheduledTimer(timeInterval: 3.0,
//                                     target: self,
//                                     selector: #selector(eventWith(timer:)),
//                                     userInfo: nil,
//                                     repeats: false)
//    }
//
//    @objc func eventWith(timer: Timer!) {
//        self.hideSVHUD()
//    }
    
    func didRequestLayerList() {
        if Layer.getAllData().count != 0 {
            return
        }
        
        LTRequest.sharedInstance().didRequestInfo(["absoluteLink":"".urlGet(postFix: "api/LayerGroup/list"),
                                                   "header":["Authorization":Information.token == nil ? "" : Information.token!],
                                                   "method":"GET",
                                                   "overrideAlert":"1"], withCache: { (cache) in
                                                    
        }) { (response, errorCode, error, isValid) in
                        
            if errorCode != "200" {
                self.showToast("Lỗi xảy ra, mời bạn thử lại", andPos: 0)
                
                self.hideSVHUD()

                return
            }
            
            for layer in (response?.dictionize()["array"] as! NSArray) {
                let layerId = (layer as! NSDictionary)["Id"]
                
                let layerData = (layer as! NSDictionary).bv_jsonString(withPrettyPrint: true)
                
                Layer.insertData(layerId: layerId as! Int32, layerData: layerData!)
            }
            
            self.didRequestCommune()
        }
    }
    
    func didRequestAllField() {
        if Field.getAllData().count != 0 {
            return
        }
        
        LTRequest.sharedInstance().didRequestInfo(["absoluteLink":"".urlGet(postFix: "api/Layer/getAllWithField"),
                                                   "header":["Authorization":Information.token == nil ? "" : Information.token!],
                                                   "method":"GET",
                                                   "overrideAlert":"1"], withCache: { (cache) in
                                                    
        }) { (response, errorCode, error, isValid) in
            
            if errorCode != "200" {
                self.showToast("Lỗi xảy ra, mời bạn thử lại", andPos: 0)
                
                self.hideSVHUD()

                return
            }
            
            for layer in (response?.dictionize()["array"] as! NSArray) {
                let layerId = (layer as! NSDictionary)["Id"]
                
                let moduleId = (layer as! NSDictionary)["ModuleId"]

                let layerData = (layer as! NSDictionary).bv_jsonString(withPrettyPrint: true)
                
                Field.insertData(layerId: layerId as! Int32, layerData: layerData!, moduleId: moduleId as! Int32)
            }
            
            self.didRequestLayerList()
        }
    }
    
    func didRequestCommune() {
        if Commune.getAllData().count != 0 {
            return
        }
        
        LTRequest.sharedInstance().didRequestInfo(["absoluteLink":"".urlGet(postFix: "api/Region/listCommune"),
                                                   "header":["Authorization":Information.token == nil ? "" : Information.token!],
                                                   "method":"GET",
                                                   "overrideAlert":"1"], withCache: { (cache) in
                                                    
        }) { (response, errorCode, error, isValid) in
            
            if errorCode != "200" {
                self.showToast("Lỗi xảy ra, mời bạn thử lại", andPos: 0)
                
                self.hideSVHUD()

                return
            }
            
            for layer in (response?.dictionize()["array"] as! NSArray) {
                let communeId = (layer as! NSDictionary)["area_id"]
                
                let communeData = (layer as! NSDictionary).bv_jsonString(withPrettyPrint: true)
                
                Commune.insertData(layerId: communeId as! Int32, layerData: communeData!)
            }
            
            self.didRequestDistrict()
        }
    }
    
    func didRequestDistrict() {
        if District.getAllData().count != 0 {
            return
        }
        
        LTRequest.sharedInstance().didRequestInfo(["absoluteLink":"".urlGet(postFix: "api/Region/listDistrict"),
                                                   "header":["Authorization":Information.token == nil ? "" : Information.token!],
                                                   "method":"GET",
                                                   "overrideAlert":"1"], withCache: { (cache) in
                                                    
        }) { (response, errorCode, error, isValid) in
            
            if errorCode != "200" {
                self.showToast("Lỗi xảy ra, mời bạn thử lại", andPos: 0)
                
                self.hideSVHUD()
                
                return
            }
            
            self.hideSVHUD()

            for layer in (response?.dictionize()["array"] as! NSArray) {
                let districtId = (layer as! NSDictionary)["area_id"]
                
                let districtData = (layer as! NSDictionary).bv_jsonString(withPrettyPrint: true)
                
                District.insertData(layerId: districtId as! Int32, layerData: districtData!)
            }
            
            self.showSVHUD("Cập nhật thành công", andOption: 1)
        }
    }
    
    @IBAction func didPressMenu(menu: DropButton) {
        menu.didDropDown(withData: menuList as! [Any], andInfo: ["rect":CGRect.init(x: Int(self.screenWidth() - 225), y: -135, width: 225, height: 200)]) { (objc) in
            
            if objc == nil {
                return
            }
            
            let indexing = (objc as! NSDictionary)["index"]
            
            switch (indexing as AnyObject).integerValue {
            case 0:
                Field.deleteAllData()
                Layer.deleteAllData()
                Commune.deleteAllData()
                District.deleteAllData()
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
        return CGSize(width: Int(screenHeight()/3 - 10), height: Int(screenHeight()/3 - 30))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TG_Image_Cell", for: indexPath as IndexPath)
        
        let dict = images![indexPath.item] as! NSDictionary
        
        let image = (self.withView(cell, tag: 11) as! UIImageView)
        
        image.withBorder(["Bwidth":"6", "Bcolor":UIColor.blue])

        image.image = UIImage.init(named: dict["img"] as! String)
        
        (self.withView(cell, tag: 12) as! UILabel).text = dict["title"] as? String
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let info = QL_Info_Collector_ViewController()
        
        info.type = indexPath.item
        
        self.navigationController?.pushViewController(info, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
