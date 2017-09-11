//
//  Teacher+CoreDataProperties.swift
//  Quiz
//
//  Created by Adam Eberbach on 11/9/17.
//  Copyright © 2017 Adam Eberbach. All rights reserved.
//
//

import Foundation
import CoreData


extension Teacher {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Teacher> {
        return NSFetchRequest<Teacher>(entityName: "Teacher")
    }

    @NSManaged public var quizzes: NSOrderedSet?
    @NSManaged public var students: NSSet?

}

// MARK: Generated accessors for quizzes
extension Teacher {

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

// MARK: Generated accessors for students
extension Teacher {

    @objc(addStudentsObject:)
    @NSManaged public func addToStudents(_ value: Student)

    @objc(removeStudentsObject:)
    @NSManaged public func removeFromStudents(_ value: Student)

    @objc(addStudents:)
    @NSManaged public func addToStudents(_ values: NSSet)

    @objc(removeStudents:)
    @NSManaged public func removeFromStudents(_ values: NSSet)

}

// MARK:- convenience functions
extension Teacher {
  
  // create and return a new QuizAnswer with its text and true or false status
  class func createWithLogin(login: String, inContext: NSManagedObjectContext) -> Teacher {
    
    let teacher = NSEntityDescription.insertNewObject(forEntityName: kManagedObjectIdentifier, into: inContext) as! Teacher
    teacher.login = login
    return teacher
  }
}

