//
//  InforManager+CoreDataProperties.swift
//  3400 CoreData 08
//
//  Created by Trương Quang on 7/15/19.
//  Copyright © 2019 truongquang. All rights reserved.
//
//

import Foundation
import CoreData


extension InforManager {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<InforManager> {
        return NSFetchRequest<InforManager>(entityName: "InforManager")
    }

    @NSManaged public var image: NSData?
    @NSManaged public var name: String?
    @NSManaged public var phonenumber: String?
    @NSManaged public var address: String?

}
