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
    var states: [State] = []
    
    func loadStates (with context: NSManagedObjectContext) {
        let fetchResquest: NSFetchRequest<State> = State.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        fetchResquest.sortDescriptors = [sortDescriptor]
        
        do {
            states = try context.fetch(fetchResquest)
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func deleteState(index: Int,with context: NSManagedObjectContext) {
        let state = states[index]
       
        context.delete(state)
 
        do {
           
            try context.save()
            
            
        } catch{
                print(error.localizedDescription)
    }
    }
    
    private init()
    {
        
    }
}

