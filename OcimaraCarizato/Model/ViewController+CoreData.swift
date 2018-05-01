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
    
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    var context: NSManagedObjectContext {
        return appDelegate.persistentContainer.viewContext
    }

}

