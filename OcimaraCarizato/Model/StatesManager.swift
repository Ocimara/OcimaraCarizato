//
//  File.swift
//  OcimaraCarizato
//
//  Created by Ocimara Barcellos on 29/04/2018.
//  Copyright © 2018 Ocimara Barcellos. All rights reserved.
//

import Foundation
import CoreData


class StatesManager {
        static let shared = StatesManager()
  
     var fetchedResultsControllerState: NSFetchedResultsController<State>!
    
    func loadStates (with context: NSManagedObjectContext) {
        let fetchResquest: NSFetchRequest<State> = State.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        fetchResquest.sortDescriptors = [sortDescriptor]
        
       // do {
       //     states = try context.fetch(fetchResquest)
       // } catch {
       //     print(error.localizedDescription)
       // }
        fetchedResultsControllerState = NSFetchedResultsController(fetchRequest: fetchResquest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try    fetchedResultsControllerState.performFetch()
        } catch  {
            print(error.localizedDescription)
        }
        
        
    }
    
    func deleteState(index: Int,with context: NSManagedObjectContext) {
        guard let state = fetchedResultsControllerState.fetchedObjects?[index] else {return}
        
        if state.relationProduct!.count > 0 {
            
            let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "relationState.title = %@", state.title!)
            
            let entityDescription = NSEntityDescription.entity(forEntityName: "Product", in: context)
            fetchRequest.entity = entityDescription
            
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            //deleteRequest.resultType = .resultTypeCount
            deleteRequest.resultType = .resultTypeObjectIDs
            
            
           do {
                try context.execute(deleteRequest)
                try context.save()
                context.delete(state)
                try context.save()
                //context.reset()
            } catch{
                print(error.localizedDescription)
            }
            
        }
        else
        {
            do {
                context.delete(state)
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
        
    
        
    }
    
    
    private init()
    {
        
    }
}

