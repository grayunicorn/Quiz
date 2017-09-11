//
//  QuizAnswer+CoreDataProperties.swift
//  Quiz
//
//  Created by Adam Eberbach on 11/9/17.
//  Copyright © 2017 Adam Eberbach. All rights reserved.
//
//

import Foundation
import CoreData


extension QuizAnswer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<QuizAnswer> {
        return NSFetchRequest<QuizAnswer>(entityName: "QuizAnswer")
    }

    @NSManaged public var isCorrect: Bool
    @NSManaged public var text: String?
    @NSManaged public var question: QuizQuestion?

}

// MARK:- convenience functions
extension QuizAnswer {
  
  // create and return a new QuizAnswer with its text and true or false status
  class func createWithText(text: String, isCorrect: String?, inContext: NSManagedObjectContext) -> QuizAnswer {
    
    let answer = NSEntityDescription.insertNewObject(forEntityName: kManagedObjectIdentifier, into: inContext) as! QuizAnswer
    answer.text = text
    // isCorrect string must be both non-optional and equal to T or t to make this a true answer
    if let isCorrect = isCorrect, isCorrect == "T" {
      answer.isCorrect = true
    } else {
      answer.isCorrect = false
    }
    return answer
  }
}
