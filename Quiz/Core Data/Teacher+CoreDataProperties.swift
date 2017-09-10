//
//  Teacher+CoreDataProperties.swift
//  Quiz
//
//  Created by Adam Eberbach on 10/9/17.
//  Copyright © 2017 Adam Eberbach. All rights reserved.
//
//

import Foundation
import CoreData


extension Teacher {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Teacher> {
        return NSFetchRequest<Teacher>(entityName: "Teacher")
    }

    @NSManaged public var quizzes: NSSet?
    @NSManaged public var students: NSSet?

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

// MARK: Generated accessors for quizzes
extension Teacher {

    @objc(addQuizzesObject:)
    @NSManaged public func addToQuizzes(_ value: QuizCollection)

    @objc(removeQuizzesObject:)
    @NSManaged public func removeFromQuizzes(_ value: QuizCollection)

    @objc(addQuizzes:)
    @NSManaged public func addToQuizzes(_ values: NSSet)

    @objc(removeQuizzes:)
    @NSManaged public func removeFromQuizzes(_ values: NSSet)

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
