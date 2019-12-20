//
//  CoreDataMethodsVC.swift
//  MyNewDemos
//
//  Created by apple on 27/08/19.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit
import CoreData






class CoreDataMethods {

    static let keys:[String] = ["objId","firstName","surname","mobile","email","address","dob","company","pincode","date","url"]
    
     static let updateKeys:[String] = ["firstName","surname","mobile","email","address","dob","company","pincode","date","url"]
    static let databaseName = "ContactDatabase"
    
    // MARK:- getAllData
    static func getAllData(entityName:String,isAssending:Bool) -> [NSManagedObject]
    {
         var ContactData = [NSManagedObject]()
         let appDelegate = UIApplication.shared.delegate as! AppDelegate
         let objContext:NSManagedObjectContext! =  appDelegate.persistentContainer.viewContext
         let request = NSFetchRequest<NSFetchRequestResult>(entityName:entityName)
        // it is used to Sort data in A-Z or Z-A
         let nameSort = NSSortDescriptor(key:"firstName", ascending:isAssending)
         request.sortDescriptors = [nameSort]
         request.returnsObjectsAsFaults = false
       
        do{
            let Data = try  objContext.fetch(request)
            print("We got new Data::",Data)
            ContactData = Data as! [NSManagedObject]
        }
        catch{
            print("Error Something wrong in Database....")
        }
        
        return ContactData
    }
    
    
    // MARK:- insertNewObj
    static func insertNewObj(forEntityName:String,keys:[String],values:[String],isImage:Bool,imageData:Data) -> Bool
    {
       
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let objContext:NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let coreDataObj:NSManagedObject = NSEntityDescription.insertNewObject(forEntityName: forEntityName, into: objContext)
        
        for i in 0..<keys.count{
            coreDataObj.setValue(values[i], forKey: keys[i])
        }
       
        coreDataObj.setValue(isImage, forKey: "isImage")
        
        if isImage{
            coreDataObj.setValue(imageData, forKey: "image")
        }
        
        
        do{
            try objContext.save()
            print("Success: Data Saved........")
             return true
        }catch{
            print("Error: Data Not Saved")
             return false
        }
       
    }
    
    
    
     // MARK:- deleteSingleObj
    static func deleteSingleObj(objId:String,entityName:String) -> Bool
    {
        print("objId::::::::::",objId)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let objContext:NSManagedObjectContext! =  appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:entityName)
        request.predicate = NSPredicate(format: "(objId = %@)", argumentArray: [objId])
            //NSPredicate.init(format: "objId==\(objId)")
        let objects = try! objContext.fetch(request)
        print("deleteSingleObj Count:::",objects.count)
        for obj in objects {
            objContext.delete(obj as! NSManagedObject)
        }
        
        do {
            try objContext.save() // <- remember to put this :)
            return true
        } catch {
            return false
            // Do something... fatalerror
        }
        
    }

     // MARK:- deleteMultipleObj
    static func deleteMultipleObj(objId:[String]) -> Bool
    {
        
        return true
    }
    
    
    // MARK:- updateSingleObj
    static func updateSingleObj(forEntityName:String,objId:String,keys:[String],values:[String],isImage:Bool,imageData:Data) -> Bool
    {
     
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let objContext:NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:forEntityName)
        request.returnsObjectsAsFaults = false
        
        let predicate = NSPredicate(format: "(objId = %@)",objId)
        request.predicate = predicate
        
        do{
            let Data = try  objContext.fetch(request)
            let objectUpdate = Data.first as! NSManagedObject
            for i in 0..<keys.count{
                objectUpdate.setValue(values[i], forKey: keys[i])
            }
            
            objectUpdate.setValue(isImage, forKey: "isImage")
            
            if isImage{
                objectUpdate.setValue(imageData, forKey: "image")
            }
            
            
            do{
                try objContext.save()
                print("Success: Data Updated........")
            }catch{
                print("Error: Data Not Saved")
            }
            
            
        }
        catch{
            print("Error Something wrong in Database....")
        }
        
        return true
    }
    
    
    
}
