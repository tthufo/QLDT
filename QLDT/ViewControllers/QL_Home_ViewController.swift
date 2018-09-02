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
    
    var images: NSMutableArray? = ["","","","",""]
    
    let menuList: NSArray = [["title":"Đồng bộ danh mục", "ima":"ic_pass"], ["title":"Thay đổi địa chỉ máy chủ", "ima":"ic_pass"], ["title":"Thay đổi mật khẩu", "ima":"ic_pass"], ["title":"Cài đặt", "ima":"ic_pass"], ["title":"Đăng xuất", "ima":"ic_pass"], ["title":"Thoát", "ima":"ic_pass"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.withCell("TG_Image_Cell")
        
        didRequestAllField()
    }

    func didRequestUserInfo() {
        LTRequest.sharedInstance().didRequestInfo(["absoluteLink":"".urlGet(postFix: "api/LayerGroup/list"),
                                                   "header":["Authorization":Information.token == nil ? "" : Information.token!],
                                                   "method":"GET",
                                                   "overrideAlert":"1",
                                                   "host":self], withCache: { (cache) in
                                                    
        }) { (response, errorCode, error, isValid) in
                        
            if errorCode != "200" {
                self.showToast("Lỗi xảy ra, mời bạn thử lại", andPos: 0)
                
                return
            }
            
            print((response?.dictionize()["array"] as! NSArray)[0])
            
//            self.add(response?.dictionize().reFormat() as! [AnyHashable : Any], andKey: "info")
        }
    }
    
    func didRequestAllField() {
        LTRequest.sharedInstance().didRequestInfo(["absoluteLink":"".urlGet(postFix: "api/Layer/getAllWithField"),
                                                   "header":["Authorization":Information.token == nil ? "" : Information.token!],
                                                   "method":"GET",
                                                   "overrideAlert":"1",
                                                   "host":self], withCache: { (cache) in
                                                    
        }) { (response, errorCode, error, isValid) in
            
            if errorCode != "200" {
                self.showToast("Lỗi xảy ra, mời bạn thử lại", andPos: 0)
                
                return
            }
            
            let layerId = ((response?.dictionize()["array"] as! NSArray)[0] as! NSDictionary)["LayerId"]
            
            let layerData = ((response?.dictionize()["array"] as! NSArray)[0] as! NSDictionary).bv_jsonString(withPrettyPrint: true)
            
            //LayerField.insertData(layerId: layerId as! Int32, layerData: layerData!)
            
            LayerField.getAllData()
        }
    }
    
    @IBAction func didPressMenu(menu: DropButton) {
        menu.didDropDown(withData: menuList as! [Any], andInfo: ["rect":CGRect.init(x: Int(self.screenWidth() - 225), y: -135, width: 225, height: 200)]) { (objc) in
            
            let indexing = (objc as! NSDictionary)["index"]
            
            switch (indexing as AnyObject).integerValue {
            case 0:
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
        return CGSize(width: Int(screenWidth()/2 - 0), height: Int(screenWidth()/2 - 0))
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
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
