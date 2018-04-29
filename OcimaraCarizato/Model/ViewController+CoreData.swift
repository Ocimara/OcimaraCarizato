//
//  ViewController+CoreData.swift
//  OcimaraCarizato
//
//  Created by Ocimara Barcellos on 20/04/2018.
//  Copyright © 2018 Ocimara Barcellos. All rights reserved.
//
import UIKit
import CoreData

extension UIViewController {
    
    var context: NSManagedObjectContext {
    
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        return appDelegate.persistentContainer.viewContext
        
    }

}

