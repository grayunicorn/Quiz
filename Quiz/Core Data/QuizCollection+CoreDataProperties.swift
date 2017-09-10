//
//  QuizCollection+CoreDataProperties.swift
//  Quiz
//
//  Created by Adam Eberbach on 10/9/17.
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
    @NSManaged public var questions: NSSet?
    @NSManaged public var students: Student?
    @NSManaged public var teachers: Teacher?

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

// MARK: Generated accessors for questions
extension QuizCollection {

    @objc(addQuestionsObject:)
    @NSManaged public func addToQuestions(_ value: QuizQuestion)

    @objc(removeQuestionsObject:)
    @NSManaged public func removeFromQuestions(_ value: QuizQuestion)

    @objc(addQuestions:)
    @NSManaged public func addToQuestions(_ values: NSSet)

    @objc(removeQuestions:)
    @NSManaged public func removeFromQuestions(_ values: NSSet)

}
