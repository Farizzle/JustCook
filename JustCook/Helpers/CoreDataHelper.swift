//
//  CoreDataHerlp.swift
//  JustCook
//
//  Created by Metricell Developer on 16/01/2019.
//  Copyright © 2019 Faris Zaman. All rights reserved.
//

import UIKit
import CoreData

struct CoreDataHelper {
    
    static public func saveUser(entityName: String, servingSize: Int, budget: Int, selectedDate: String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: managedContext)!
        
        let user = NSManagedObject(entity: entity, insertInto: managedContext)
        
        user.setValue(servingSize, forKey: "servingSize")
        user.setValue(budget, forKey: "budget")
        user.setValue(selectedDate, forKey: "selectedDates")
        
        do {
            try managedContext.save()
            print("Saved user information successfully")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    static public func loadCoreData(entityName: String) -> [NSManagedObject] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return [NSManagedObject].init()
        }
        var userDetails: [NSManagedObject] = []
    
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        
        do {
            userDetails = try managedContext.fetch(fetchRequest)
            print("Loaded user information successfully")
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return userDetails
    }

}
