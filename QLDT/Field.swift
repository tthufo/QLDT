//
//  Field.swift
//  QLDT
//
//  Created by Thanh Hai Tran on 9/3/18.
//  Copyright © 2018 Thanh Hai Tran. All rights reserved.
//

import UIKit

import CoreData

class Field {
    
    static func contexting() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if #available(iOS 10.0, *) {
            return appDelegate.persistentContainer.viewContext
        } else {
            return CoreDataStack.managedObjectContext
        }
    }
    
    static func insertData(layerId: Int32, layerData: String, moduleId: Int32) {
        
        if getData(layerId: layerId).count != 0 {
            return
        }
        
        let entity = NSEntityDescription.entity(forEntityName: "FieldGroup", in: contexting())
        let newUser = NSManagedObject(entity: entity!, insertInto: contexting())
        
        newUser.setValue(moduleId, forKey: "moduleId")
        newUser.setValue(layerId, forKey: "layerId")
        newUser.setValue(layerData, forKey: "layerData")
        
        do {
            try contexting().save()
        } catch {
            print("Failed saving")
        }
    }
    
    static func getDataModule(moduleId: Int32) -> [NSMutableDictionary] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FieldGroup")
        request.predicate = NSPredicate(format: "moduleId = %i", moduleId)
        request.returnsObjectsAsFaults = false
        var array = [NSMutableDictionary]()
        do {
            let result = try contexting().fetch(request)
            for data in result as! [NSManagedObject] {
                array.append(((data as! FieldGroup).layerData?.dictionize().reFormat())!)
            }
        } catch {
            print("Failed")
        }
        
        return array
    }
    
    static func getData(layerId: Int32) -> [NSMutableDictionary] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FieldGroup")
        request.predicate = NSPredicate(format: "layerId = %i", layerId)
        request.returnsObjectsAsFaults = false
        var array = [NSMutableDictionary]()
        do {
            let result = try contexting().fetch(request)
            for data in result as! [NSManagedObject] {
                array.append(((data as! FieldGroup).layerData?.dictionize().reFormat())!)
            }
        } catch {
            print("Failed")
        }
        
        return array
    }
    
    static func getAllData() -> [NSMutableDictionary] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FieldGroup")
        request.returnsObjectsAsFaults = false
        var array = [NSMutableDictionary]()
        do {
            let result = try contexting().fetch(request)
            for data in result as! [NSManagedObject] {
                array.append(((data as! FieldGroup).layerData?.dictionize().reFormat())!)
            }
        } catch {
            print("Failed")
        }
        
        return array
    }
    
    static func deleteAllData() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FieldGroup")
        request.returnsObjectsAsFaults = false
        do {
            let results = try contexting().fetch(request)
            for managedObject in results {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                contexting().delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Detele all data in Layer error : \(error) \(error.userInfo)")
        }
    }
}
