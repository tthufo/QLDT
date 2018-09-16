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
    
    static func insertData(parentId: Int32, tempData: String, title: String, date: String) {
        
        let entity = NSEntityDescription.entity(forEntityName: "TempData", in: contexting())
        let newUser = NSManagedObject(entity: entity!, insertInto: contexting())
        
        newUser.setValue(parentId, forKey: "parentId")
        newUser.setValue(tempData, forKey: "tempData")
        newUser.setValue(title, forKey: "title")
        newUser.setValue(Int32(contexting().autoIncrement("auto")), forKey: "id")
        newUser.setValue(date, forKey: "createDate")
        newUser.setValue(date, forKey: "modifyDate")

        do {
            try contexting().save()
        } catch {
            print("Failed saving")
        }
    }
    
    static func modifyData(id: Int32, parentId: Int32, tempData: String, date: String) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TempData")
        request.predicate = NSPredicate(format: "id = %i AND parentId = %i", id, parentId)
        request.returnsObjectsAsFaults = false
        do {
            let results = try contexting().fetch(request)
            
            let object = results.first as! NSManagedObject
            
            object.setValue(tempData, forKey: "tempData")
            
            object.setValue(date, forKey: "modifyDate")

            try contexting().save()

        } catch let error as NSError {
            print("Detele all data in Field error : \(error) \(error.userInfo)")
        }
    }
    
    static func getData(id: Int32, parentId: Int32) -> [NSMutableDictionary] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TempData")
        request.predicate = NSPredicate(format: "id = %i AND parentId = %i", id, parentId)
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
    
    static func getDataTemp(parentId: Int32) -> [NSManagedObject] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TempData")
        if parentId != -1 {
            request.predicate = NSPredicate(format: "parentId = %i", parentId)
        }
        let idDescriptor: NSSortDescriptor = NSSortDescriptor(key: "id", ascending: false)
        request.sortDescriptors = [idDescriptor]
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
            
            try contexting().save()

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
            
            try contexting().save()
            
        } catch let error as NSError {
            print("Detele all data in Field error : \(error) \(error.userInfo)")
        }
    }
}

