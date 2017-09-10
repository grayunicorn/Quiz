//
//  Student+CoreDataProperties.swift
//  Quiz
//
//  Created by Adam Eberbach on 10/9/17.
//  Copyright © 2017 Adam Eberbach. All rights reserved.
//
//

import Foundation
import CoreData


extension Student {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Student> {
        return NSFetchRequest<Student>(entityName: "Student")
    }

    @NSManaged public var quizzes: NSSet?
    @NSManaged public var relationship: Teacher?

}

// MARK:- convenience functions
extension Student {
  
  // create and return a new QuizAnswer with its text and true or false status
  class func createWithLogin(login: String, inContext: NSManagedObjectContext) -> Student {
    
    let student = NSEntityDescription.insertNewObject(forEntityName: kManagedObjectIdentifier, into: inContext) as! Student
    student.login = login
    return student
  }
}

// MARK: Generated accessors for quizzes
extension Student {

    @objc(addQuizzesObject:)
    @NSManaged public func addToQuizzes(_ value: QuizCollection)

    @objc(removeQuizzesObject:)
    @NSManaged public func removeFromQuizzes(_ value: QuizCollection)

    @objc(addQuizzes:)
    @NSManaged public func addToQuizzes(_ values: NSSet)

    @objc(removeQuizzes:)
    @NSManaged public func removeFromQuizzes(_ values: NSSet)

}
