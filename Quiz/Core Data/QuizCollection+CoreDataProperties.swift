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
  class func createWithTitle(_ text: String, forTeacher: Teacher, inContext: NSManagedObjectContext) -> QuizCollection {
    
    let collection = NSEntityDescription.insertNewObject(forEntityName: kManagedObjectIdentifier, into: inContext) as! QuizCollection
    collection.text = text
    forTeacher.addToQuizzes(collection)
    return collection
  }
}

