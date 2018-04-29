//
//  Product+CoreDataProperties.swift
//  OcimaraCarizato
//
//  Created by Ocimara Barcellos on 28/04/2018.
//  Copyright © 2018 Ocimara Barcellos. All rights reserved.
//
//

import Foundation
import CoreData


extension Product {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
        return NSFetchRequest<Product>(entityName: "Product")
    }

    @NSManaged public var flCard: Bool
    @NSManaged public var imgProduct: NSObject?
    @NSManaged public var title: String?
    @NSManaged public var vlProduct: Double
    @NSManaged public var relationProduct: State?

}
