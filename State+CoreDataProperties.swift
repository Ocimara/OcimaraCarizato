//
//  State+CoreDataProperties.swift
//  OcimaraCarizato
//
//  Created by Ocimara Barcellos on 28/04/2018.
//  Copyright © 2018 Ocimara Barcellos. All rights reserved.
//
//

import Foundation
import CoreData


extension State {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<State> {
        return NSFetchRequest<State>(entityName: "State")
    }

    @NSManaged public var title: String?
    @NSManaged public var tax: Double
    @NSManaged public var relationState: NSSet?

}

// MARK: Generated accessors for relationState
extension State {

    @objc(addRelationStateObject:)
    @NSManaged public func addToRelationState(_ value: Product)

    @objc(removeRelationStateObject:)
    @NSManaged public func removeFromRelationState(_ value: Product)

    @objc(addRelationState:)
    @NSManaged public func addToRelationState(_ values: NSSet)

    @objc(removeRelationState:)
    @NSManaged public func removeFromRelationState(_ values: NSSet)

}
