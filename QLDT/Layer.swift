//
//  Field.swift
//  QLDT
//
//  Created by Thanh Hai Tran on 9/3/18.
//  Copyright © 2018 Thanh Hai Tran. All rights reserved.
//

import UIKit
import CoreData

class Layer {
    
    static func contexting() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        return context
    }
    
    static func insertData(layerId: Int32, layerData: String) {
        
        if getData(layerId: layerId).count != 0 {
            return
        }
        
        let entity = NSEntityDescription.entity(forEntityName: "LayerGroup", in: contexting())
        let newUser = NSManagedObject(entity: entity!, insertInto: contexting())
        
        
        newUser.setValue(layerId, forKey: "layerId")
        newUser.setValue(layerData, forKey: "layerData")
        do {
            try contexting().save()
        } catch {
            print("Failed saving")
        }
    }
    
    static func getData(layerId: Int32) -> [NSMutableDictionary] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "LayerGroup")
        request.predicate = NSPredicate(format: "layerId = %i", layerId)
        request.returnsObjectsAsFaults = false
        var array = [NSMutableDictionary]()
        do {
            let result = try contexting().fetch(request)
            for data in result as! [NSManagedObject] {
                array.append(((data as! LayerGroup).layerData?.dictionize().reFormat())!)
            }
        } catch {
            print("Failed")
        }
        
        return array
    }
    
    static func getAllData() -> [NSMutableDictionary] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "LayerGroup")
        request.returnsObjectsAsFaults = false
        var array = [NSMutableDictionary]()
        do {
            let result = try contexting().fetch(request)
            for data in result as! [NSManagedObject] {
                array.append(((data as! LayerGroup).layerData?.dictionize().reFormat())!)
            }
        } catch {
            print("Failed")
        }
        
        return array
    }
    
    static func deleteAllData() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "LayerGroup")
        request.returnsObjectsAsFaults = false
        do {
            let results = try contexting().fetch(request)
            for managedObject in results {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                contexting().delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Detele all data in Field error : \(error) \(error.userInfo)")
        }
    }
}
