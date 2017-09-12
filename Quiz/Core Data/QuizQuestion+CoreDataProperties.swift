//
//  QuizQuestion+CoreDataProperties.swift
//  Quiz
//
//  Created by Adam Eberbach on 12/9/17.
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
    @NSManaged public var assignedPercentage: Int16
    @NSManaged public var answers: NSOrderedSet?
    @NSManaged public var collection: QuizCollection?

}

// MARK: Generated accessors for answers
extension QuizQuestion {

    @objc(insertObject:inAnswersAtIndex:)
    @NSManaged public func insertIntoAnswers(_ value: QuizAnswer, at idx: Int)

    @objc(removeObjectFromAnswersAtIndex:)
    @NSManaged public func removeFromAnswers(at idx: Int)

    @objc(insertAnswers:atIndexes:)
    @NSManaged public func insertIntoAnswers(_ values: [QuizAnswer], at indexes: NSIndexSet)

    @objc(removeAnswersAtIndexes:)
    @NSManaged public func removeFromAnswers(at indexes: NSIndexSet)

    @objc(replaceObjectInAnswersAtIndex:withObject:)
    @NSManaged public func replaceAnswers(at idx: Int, with value: QuizAnswer)

    @objc(replaceAnswersAtIndexes:withAnswers:)
    @NSManaged public func replaceAnswers(at indexes: NSIndexSet, with values: [QuizAnswer])

    @objc(addAnswersObject:)
    @NSManaged public func addToAnswers(_ value: QuizAnswer)

    @objc(removeAnswersObject:)
    @NSManaged public func removeFromAnswers(_ value: QuizAnswer)

    @objc(addAnswers:)
    @NSManaged public func addToAnswers(_ values: NSOrderedSet)

    @objc(removeAnswers:)
    @NSManaged public func removeFromAnswers(_ values: NSOrderedSet)

}

// MARK: convenience functions
extension QuizQuestion {
  
  // create and return a new QuizQuestion with its text
  class func createWithText(text: String, inContext: NSManagedObjectContext) -> QuizQuestion {
    
    let question = NSEntityDescription.insertNewObject(forEntityName: kManagedObjectIdentifier, into: inContext) as! QuizQuestion
    question.text = text
    return question;
  }
  
  func answerNumber(_ number: Int) -> QuizAnswer? {
    
    var foundAnswer: QuizAnswer?
    if let answers = answers {
      if number < answers.count {
        let answer = answers[number] as! QuizAnswer
        foundAnswer = answer
      }
    }
    return foundAnswer
  }
}

