//
//  CoreDataStack.swift
//  TheMoviePADC
//
//  Created by Wai Yan Moe on 30/06/2023.
//
import Foundation
import CoreData
class CoreDataStack : NSObject {
    
    static let shared = CoreDataStack()
    
    let persistentContainer : NSPersistentContainer
    
    var context : NSManagedObjectContext {
        get{
            persistentContainer.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
            return persistentContainer.viewContext
        }
    }
    
    override init() {
        persistentContainer = NSPersistentContainer(name: "MovieDB")
        persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    func saveContext(){
        let context = self.context
        if context.hasChanges {
            do {
                try context.save()
                
            } catch {
                let error = error as NSError
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    
    

}
