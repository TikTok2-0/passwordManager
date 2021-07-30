//
//  Passwords+CoreDataProperties.swift
//  Password Manager Python
//
//  Created by Henry Krieger on 18.07.21.
//
//

import Foundation
import CoreData


extension Passwords {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Passwords> {
        return NSFetchRequest<Passwords>(entityName: "Passwords")
    }

    @NSManaged public var password: String
    @NSManaged public var username: String
    @NSManaged public var website: String
    @NSManaged public var keyName: String
    @NSManaged public var iv: [UInt8]

}

extension Passwords : Identifiable {

}
