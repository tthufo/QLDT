//
//  Temp.swift
//  QLDT
//
//  Created by Thanh Hai Tran on 9/16/18.
//  Copyright © 2018 Thanh Hai Tran. All rights reserved.
//

import UIKit

import CoreData

class Temp {

    static func contexting() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        return context
    }
    
    static func insertData(parentId: Int32, tempData: String, title: String) {
        
        let entity = NSEntityDescription.entity(forEntityName: "TempData", in: contexting())
        let newUser = NSManagedObject(entity: entity!, insertInto: contexting())
        
        newUser.setValue(parentId, forKey: "parentId")
        newUser.setValue(tempData, forKey: "tempData")
        newUser.setValue(title, forKey: "title")
        newUser.setValue(Int32(contexting().autoIncrement("auto")), forKey: "id")
        
        do {
            try contexting().save()
        } catch {
            print("Failed saving")
        }
    }
    
    static func getData(parentId: Int32) -> [NSMutableDictionary] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TempData")
        request.predicate = NSPredicate(format: "parentId = %i", parentId)
        let idDescriptor: NSSortDescriptor = NSSortDescriptor(key: "id", ascending: false)
        request.sortDescriptors = [idDescriptor]
        request.returnsObjectsAsFaults = false
        var array = [NSMutableDictionary]()
        do {
            let result = try contexting().fetch(request)
            for data in result as! [NSManagedObject] {
                array.append(((data as! TempData).tempData?.dictionize().reFormat())!)
            }
        } catch {
            print("Failed")
        }
        
        return array
    }
    
    static func getAllData() -> [NSMutableDictionary] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TempData")
        request.returnsObjectsAsFaults = false
        var array = [NSMutableDictionary]()
        do {
            let result = try contexting().fetch(request)
            for data in result as! [NSManagedObject] {
                array.append(((data as! TempData).tempData?.dictionize().reFormat())!)
            }
        } catch {
            print("Failed")
        }
        
        return array
    }
    
    static func deleteData(id: Int32) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TempData")
        request.predicate = NSPredicate(format: "id = %i", id)
        request.returnsObjectsAsFaults = false
        do {
            let results = try contexting().fetch(request)
            
            let object = results.first
            
            contexting().delete(object as! NSManagedObject)
            
        } catch let error as NSError {
            print("Detele all data in Field error : \(error) \(error.userInfo)")
        }
    }
    
    static func deleteAllData() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TempData")
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

