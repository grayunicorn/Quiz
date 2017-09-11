//
//  QuizCollection+CoreDataProperties.swift
//  Quiz
//
//  Created by Adam Eberbach on 11/9/17.
//  Copyright © 2017 Adam Eberbach. All rights reserved.
//
//

import Foundation
import CoreData

extension QuizCollection {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<QuizCollection> {
        return NSFetchRequest<QuizCollection>(entityName: "QuizCollection")
    }

    @NSManaged public var text: String?
    @NSManaged public var questions: NSOrderedSet?
    @NSManaged public var students: Student?
    @NSManaged public var teachers: Teacher?

}

// MARK: Generated accessors for questions
extension QuizCollection {

    @objc(insertObject:inQuestionsAtIndex:)
    @NSManaged public func insertIntoQuestions(_ value: QuizQuestion, at idx: Int)

    @objc(removeObjectFromQuestionsAtIndex:)
    @NSManaged public func removeFromQuestions(at idx: Int)

    @objc(insertQuestions:atIndexes:)
    @NSManaged public func insertIntoQuestions(_ values: [QuizQuestion], at indexes: NSIndexSet)

    @objc(removeQuestionsAtIndexes:)
    @NSManaged public func removeFromQuestions(at indexes: NSIndexSet)

    @objc(replaceObjectInQuestionsAtIndex:withObject:)
    @NSManaged public func replaceQuestions(at idx: Int, with value: QuizQuestion)

    @objc(replaceQuestionsAtIndexes:withQuestions:)
    @NSManaged public func replaceQuestions(at indexes: NSIndexSet, with values: [QuizQuestion])

    @objc(addQuestionsObject:)
    @NSManaged public func addToQuestions(_ value: QuizQuestion)

    @objc(removeQuestionsObject:)
    @NSManaged public func removeFromQuestions(_ value: QuizQuestion)

    @objc(addQuestions:)
    @NSManaged public func addToQuestions(_ values: NSOrderedSet)

    @objc(removeQuestions:)
    @NSManaged public func removeFromQuestions(_ values: NSOrderedSet)

}

// MARK: convenience functions
extension QuizCollection {
  
  // create a new QuizCollection with its title, add it to the Teacher's collection
  class func createWithTitle(_ text: String, inContext: NSManagedObjectContext) -> QuizCollection {
    
    let collection = NSEntityDescription.insertNewObject(forEntityName: kManagedObjectIdentifier, into: inContext) as! QuizCollection
    collection.text = text
    return collection
  }
  
  func questionNumber(_ number: Int) -> QuizQuestion? {
    
    var foundQuestion: QuizQuestion?
    if let questions = questions {
      if number < questions.count {
        let question = questions[number] as! QuizQuestion
        foundQuestion = question
      }
    }
    return foundQuestion
  }
  
  // duplicate this quiz collection, but make every answer false/empty
  // this method uses some unsafe ! unwraps - but if there were any chance a collection was not valid things would have broken long before this point
  func duplicateWithoutAnswers(moc: NSManagedObjectContext) throws -> QuizCollection? {
    
    let newCollection = QuizCollection.createWithTitle(text!, inContext: moc)

    for question in questions! {
      
      // duplicate every question
      let thisQuestion = question as! QuizQuestion
      let newQuestion = QuizQuestion.createWithText(text: thisQuestion.text!, inContext: moc)
      newCollection.addToQuestions(newQuestion)
      
      for answer in thisQuestion.answers! {
        
        // duplicate every answer
        let thisAnswer = answer as! QuizAnswer
        let newAnswer = QuizAnswer.createWithText(text: thisAnswer.text!, isCorrect: "F", inContext: moc)
        newQuestion.addToAnswers(newAnswer)
      }
      
    }
    
    // write the new QuizCollection to the managed object context
    moc.insert(newCollection)
    try moc.save()
    
    // return the copy
    return newCollection
  }
}

