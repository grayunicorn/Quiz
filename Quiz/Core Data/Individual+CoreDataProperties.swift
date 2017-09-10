//
//  Individual+CoreDataProperties.swift
//  Quiz
//
//  Created by Adam Eberbach on 10/9/17.
//  Copyright © 2017 Adam Eberbach. All rights reserved.
//
//

import Foundation
import CoreData


extension Individual {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Individual> {
        return NSFetchRequest<Individual>(entityName: "Individual")
    }

    @NSManaged public var login: String?

}
