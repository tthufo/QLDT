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
        
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.withCell("TG_Image_Cell")
        
        didRequestUserInfo()
    }

    func didRequestUserInfo() {
        LTRequest.sharedInstance().didRequestInfo(["absoluteLink":"".urlGet(postFix: "api/LayerGroup/list"),
                                                   "header":["Authorization":Information.token == nil ? "" : Information.token!],
                                                   "method":"GET",
                                                   "overrideAlert":"1",
                                                   "host":self], withCache: { (cache) in
                                                    
        }) { (response, errorCode, error, isValid) in
            
            print(error)
            
            if errorCode != "200" {
                self.showToast("Lỗi xảy ra, mời bạn thử lại", andPos: 0)
                
                return
            }
            
            print(response)
            
//            self.add(response?.dictionize().reFormat() as! [AnyHashable : Any], andKey: "info")
        }
    }
    
    @IBAction func didPressMenu(menu: DropButton) {

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
