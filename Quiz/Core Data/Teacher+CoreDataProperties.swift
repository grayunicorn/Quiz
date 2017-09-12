//
//  Teacher+CoreDataProperties.swift
//  Quiz
//
//  Created by Adam Eberbach on 12/9/17.
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
    @NSManaged public var students: NSOrderedSet?

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

    @objc(insertObject:inStudentsAtIndex:)
    @NSManaged public func insertIntoStudents(_ value: Student, at idx: Int)

    @objc(removeObjectFromStudentsAtIndex:)
    @NSManaged public func removeFromStudents(at idx: Int)

    @objc(insertStudents:atIndexes:)
    @NSManaged public func insertIntoStudents(_ values: [Student], at indexes: NSIndexSet)

    @objc(removeStudentsAtIndexes:)
    @NSManaged public func removeFromStudents(at indexes: NSIndexSet)

    @objc(replaceObjectInStudentsAtIndex:withObject:)
    @NSManaged public func replaceStudents(at idx: Int, with value: Student)

    @objc(replaceStudentsAtIndexes:withStudents:)
    @NSManaged public func replaceStudents(at indexes: NSIndexSet, with values: [Student])

    @objc(addStudentsObject:)
    @NSManaged public func addToStudents(_ value: Student)

    @objc(removeStudentsObject:)
    @NSManaged public func removeFromStudents(_ value: Student)

    @objc(addStudents:)
    @NSManaged public func addToStudents(_ values: NSOrderedSet)

    @objc(removeStudents:)
    @NSManaged public func removeFromStudents(_ values: NSOrderedSet)

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

