//
//  CoreDataOperator.swift
//  CurrencyConverter
//
//  Created by Alex on 18.05.2021.
//  Copyright © 2021 Alex Drach. All rights reserved.

import CoreData

/// Operates CoreData actions.
class CoreDataOperator {
    
    // MARK: - Core Data stack
    
    /// Context of persistentContainer.
    static var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    /// CoreData conteiner where objects are stored.
    static private var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "SavedDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Operations
    
    /// Gets data from CoreData.
    /// - Returns: - Array of CoreData Items.
    static func getData() -> [Item] {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        do {
            return try context.fetch(request)
        }
        catch {
            return []
        }
    }
    
    /// Adds CoreData Item.
    /// - Parameters:
    ///     - item: - It's CoreData Item to add.
    static func addData(_ item: Item) {
        _ = item as NSManagedObject
        save()
    }
    
    /// Deletes CoreData Item.
    /// - Parameters:
    ///     - item: - It's CoreData Item to delete.
    static func delete(_ item: Item) {
        context.delete(item)
        save()
    }
    
    /// Saves CoreData Item.
    static private func save() {
        do {
            try context.save()
        } catch {
            persistentContainer.viewContext.rollback()
            let nserror = error as NSError
            print("\(nserror)")
        }
    }
    
    /// Indicates whether Item has the same data values with specified string code.
    /// - Parameters:
    ///     - codeGen: - It's a combined String values, to detect a similar Item.
    /// - Returns: - A Boolean value: 'true' - the Item will be updated, 'false' - will be created a new Item.
    static func itemNotExists(with codeGen: String) -> Bool {
        var exists = true
        
        for item in getData() {
            let generatedCode = "\(item.firstCode)\(item.secondCode)\(item.amount)"
            if generatedCode == codeGen {
                /// Just update the date, because all data content is the same.
                item.date = CurrentDate().toString()
                save()
                exists = false
            }
        }
        return exists
    }
    
}

