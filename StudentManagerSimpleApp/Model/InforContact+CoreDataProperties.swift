//
//  InforContact+CoreDataProperties.swift
//  StudentManagerSimpleApp
//
//  Created by Trương Quang on 9/16/19.
//  Copyright © 2019 truongquang. All rights reserved.
//
//

import Foundation
import CoreData


extension InforContact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<InforContact> {
        return NSFetchRequest<InforContact>(entityName: "InforContact")
    }

    @NSManaged public var address: String?
    @NSManaged public var image: NSData?
    @NSManaged public var name: String?
    @NSManaged public var phoneNumber: String?

}
