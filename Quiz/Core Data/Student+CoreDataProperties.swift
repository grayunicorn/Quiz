//
//  Student+CoreDataProperties.swift
//  Quiz
//
//  Created by Adam Eberbach on 11/9/17.
//  Copyright © 2017 Adam Eberbach. All rights reserved.
//
//

import Foundation
import CoreData


extension Student {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Student> {
        return NSFetchRequest<Student>(entityName: "Student")
    }

    @NSManaged public var quizzes: NSOrderedSet?
    @NSManaged public var teacher: Teacher?

}

// MARK: Generated accessors for quizzes
extension Student {

    @objc(insertObject:inQuizzesAtIndex:)
    @NSManaged public func insertIntoQuizzes(_ value: QuizCollection, at idx: Int)

    @objc(removeObjectFromQuizzesAtIndex:)
    @NSManaged public func removeFromQuizzes(at idx: Int)

    @objc(insertQuizzes:atIndexes:)
    @NSManaged public func insertIntoQuizzes(_ values: [QuizCollection], at indexes: NSIndexSet)

    @objc(removeQuizzesAtIndexes:)
    @NSManaged public func removeFromQuizzes(at indexes: NSIndexSet)

    @objc(replaceObjectInQuizzesAtIndex:withObject:)
    @NSManaged public func replaceQuizzes(at idx: Int, with value: QuizCollection)

    @objc(replaceQuizzesAtIndexes:withQuizzes:)
    @NSManaged public func replaceQuizzes(at indexes: NSIndexSet, with values: [QuizCollection])

    @objc(addQuizzesObject:)
    @NSManaged public func addToQuizzes(_ value: QuizCollection)

    @objc(removeQuizzesObject:)
    @NSManaged public func removeFromQuizzes(_ value: QuizCollection)

    @objc(addQuizzes:)
    @NSManaged public func addToQuizzes(_ values: NSOrderedSet)

    @objc(removeQuizzes:)
    @NSManaged public func removeFromQuizzes(_ values: NSOrderedSet)

}

// MARK:- convenience functions
extension Student {
  
  // create and return a new QuizAnswer with its text and true or false status
  class func createWithLogin(login: String, inContext: NSManagedObjectContext) -> Student {
    
    let student = NSEntityDescription.insertNewObject(forEntityName: kManagedObjectIdentifier, into: inContext) as! Student
    student.login = login
    return student
  }
  
  func gradeableResults() -> [QuizCollection] {

    var gradeable: [QuizCollection] = []
    for quiz in quizzes! {
      
      let thisQuiz = quiz as! QuizCollection
      if thisQuiz.isGradeable() {
        gradeable.append(thisQuiz)
      }
    }
    return gradeable
  }
  
  // return all the QuizCollection objects owned by this student that can't be graded yet
  func quizzesRequiringGrading() -> [QuizCollection] {
  
    var needGrading: [QuizCollection] = []
    
    for quiz in quizzes! {
      
      let thisQuiz = quiz as! QuizCollection
      if thisQuiz.isGradeable() == false {
        needGrading.append(thisQuiz)
      }
    }
    return needGrading
  }
}

