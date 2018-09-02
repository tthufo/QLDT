//
//  Field.swift
//  QLDT
//
//  Created by Thanh Hai Tran on 9/3/18.
//  Copyright © 2018 Thanh Hai Tran. All rights reserved.
//

import UIKit
import CoreData

class LayerField {
    
    static func contexting() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        return context
    }
    
    static func insertData(layerId: Int32, layerData: String) {
        let entity = NSEntityDescription.entity(forEntityName: "Field", in: contexting())
        let newUser = NSManagedObject(entity: entity!, insertInto: contexting())
        
        
        newUser.setValue(layerId, forKey: "layerId")
        newUser.setValue(layerData, forKey: "layerData")
        do {
            try contexting().save()
        } catch {
            print("Failed saving")
        }
    }
    
    static func getAllData() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Field")
        //request.predicate = NSPredicate(format: "age = %@", "12")
        request.returnsObjectsAsFaults = false
        do {
            let result = try contexting().fetch(request)
            for data in result as! [NSManagedObject] {
                print(data.value(forKey: "layerData"))
            }
        } catch {
            print("Failed")
        }
    }
}
