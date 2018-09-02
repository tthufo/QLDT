//
//  Field.swift
//  QLDT
//
//  Created by Thanh Hai Tran on 9/3/18.
//  Copyright © 2018 Thanh Hai Tran. All rights reserved.
//

import UIKit
import CoreData

class CommuneField {
    
    static func contexting() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        return context
    }
    
    static func insertData(layerId: Int32, layerData: String) {
        
        if getData(layerId: layerId).count != 0 {
            return
        }
        
        let entity = NSEntityDescription.entity(forEntityName: "Commune", in: contexting())
        let newUser = NSManagedObject(entity: entity!, insertInto: contexting())
        
        
        newUser.setValue(layerId, forKey: "areaId")
        newUser.setValue(layerData, forKey: "areaData")
        do {
            try contexting().save()
        } catch {
            print("Failed saving")
        }
    }
    
    static func getData(layerId: Int32) -> [NSManagedObject] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Commune")
        request.predicate = NSPredicate(format: "areaId = %i", layerId)
        request.returnsObjectsAsFaults = false
        var array = [NSManagedObject]()
        do {
            let result = try contexting().fetch(request)
            for data in result as! [NSManagedObject] {
                array.append(data)
            }
        } catch {
            print("Failed")
        }
        
        return array
    }
    
    static func getAllData() -> [NSManagedObject] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Commune")
        request.returnsObjectsAsFaults = false
        var array = [NSManagedObject]()
        do {
            let result = try contexting().fetch(request)
            for data in result as! [NSManagedObject] {
                array.append(data)
            }
        } catch {
            print("Failed")
        }
        
        return array
    }
    
    static func deleteAllData() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Commune")
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
