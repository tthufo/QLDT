//
//  Field.swift
//  QLDT
//
//  Created by Thanh Hai Tran on 9/3/18.
//  Copyright © 2018 Thanh Hai Tran. All rights reserved.
//

import UIKit
import CoreData

class Commune {
    
    static func contexting() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if #available(iOS 10.0, *) {
            return appDelegate.persistentContainer.viewContext
        } else {
            return CoreDataStack.managedObjectContext
        }
    }
    
    static func insertData(layerId: Int32, layerData: String) {
        
        if getData(layerId: layerId).count != 0 {
            return
        }
        
        let entity = NSEntityDescription.entity(forEntityName: "CommuneGroup", in: contexting())
        let newUser = NSManagedObject(entity: entity!, insertInto: contexting())
        
        
        newUser.setValue(layerId, forKey: "areaId")
        newUser.setValue(layerData, forKey: "areaData")
        do {
            try contexting().save()
        } catch {
            print("Failed saving")
        }
    }
    
    static func getData(layerId: Int32) -> [NSDictionary] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CommuneGroup")
        request.predicate = NSPredicate(format: "areaId = %i", layerId)
        request.returnsObjectsAsFaults = false
        var array = [NSDictionary]()
        do {
            let result = try contexting().fetch(request)
            for data in result as! [NSManagedObject] {
                array.append(((data as! CommuneGroup).areaData?.dictionize().reFormat())!)
            }
        } catch {
            print("Failed")
        }
        
        return array
    }
    
    static func getAllData() -> [NSDictionary] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CommuneGroup")
        request.returnsObjectsAsFaults = false
        var array = [NSDictionary]()
        do {
            let result = try contexting().fetch(request)
            for data in result as! [NSManagedObject] {
                array.append(((data as! CommuneGroup).areaData?.dictionize().reFormat())!)
            }
        } catch {
            print("Failed")
        }
        
        return array
    }
    
    static func deleteAllData() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CommuneGroup")
        request.returnsObjectsAsFaults = false
        do {
            let results = try contexting().fetch(request)
            for managedObject in results {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                contexting().delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Detele all data in Commune error : \(error) \(error.userInfo)")
        }
    }
}
