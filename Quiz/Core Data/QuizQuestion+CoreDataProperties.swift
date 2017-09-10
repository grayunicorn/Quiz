//
//  QuizQuestion+CoreDataProperties.swift
//  Quiz
//
//  Created by Adam Eberbach on 10/9/17.
//  Copyright © 2017 Adam Eberbach. All rights reserved.
//
//

import Foundation
import CoreData


extension QuizQuestion {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<QuizQuestion> {
        return NSFetchRequest<QuizQuestion>(entityName: "QuizQuestion")
    }

    @NSManaged public var text: String?
    @NSManaged public var answers: NSSet?
    @NSManaged public var collection: QuizCollection?

}

// MARK: convenience functions
extension QuizQuestion {
  
  // create and return a new QuizQuestion with its text
  class func createWithText(text: String, inContext: NSManagedObjectContext) -> QuizQuestion {
    
    let question = NSEntityDescription.insertNewObject(forEntityName: kManagedObjectIdentifier, into: inContext) as! QuizQuestion
    question.text = text
    return question;
  }
}

// MARK: Generated accessors for answers
extension QuizQuestion {

    @objc(addAnswersObject:)
    @NSManaged public func addToAnswers(_ value: QuizAnswer)

    @objc(removeAnswersObject:)
    @NSManaged public func removeFromAnswers(_ value: QuizAnswer)

    @objc(addAnswers:)
    @NSManaged public func addToAnswers(_ values: NSSet)

    @objc(removeAnswers:)
    @NSManaged public func removeFromAnswers(_ values: NSSet)

}
