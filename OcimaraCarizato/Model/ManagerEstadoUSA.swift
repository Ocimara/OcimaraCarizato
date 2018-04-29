//
//  ManagerEstadoUSA.swift
//  OcimaraCarizato
//
//  Created by Ocimara Barcellos on 20/04/2018.
//  Copyright © 2018 Ocimara Barcellos. All rights reserved.
//

import CoreData

class ManagerEstadoUSA {
    
    static let shared = ManagerEstadoUSA()
    var estados: [EstadoUSA] = []
    
    func loadEstadoUSA(with context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<EstadoUSA> = EstadoUSA.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "nmEstado", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            estados = try context.fetch(fetchRequest)
        } catch  {
            print(error.localizedDescription)
        }
        
    }
    
    func  deleteEstadoUSA(index: Int, context: NSManagedObjectContext) {
        let estado = estados[index]
        context.delete(estado)
        
        do {
            try context.save()
        } catch  {
            print(error.localizedDescription)
        }
        
    }
    
    
    private init(){}
}

