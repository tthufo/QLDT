//
//  Information.swift
//  TourGuide
//
//  Created by Mac on 8/18/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

class Information: NSObject {
    static var token: String?
    
    static var userInfo: NSDictionary?
    
    static var userName: String?
    
    static func saveToken() {
        
        if self.getValue("token") != nil {
            token = "Bearer %@".format(parameters: self.getValue("token"))
        } else {
            token = nil
        }
        
        if self.getValue("userName") != nil {
            userName = self.getValue("userName")
        } else {
            userName = nil
        }
    }
    
    static func saveInfo() {
        if self.getObject("info") != nil {
            userInfo = self.getObject("info")! as NSDictionary
        } else {
            userInfo = nil
        }
    }
    
    static func removeInfo() {
        
        self.removeValue("token")

        token = nil
        
        self.remove("info")

        userInfo = nil
    }
}
