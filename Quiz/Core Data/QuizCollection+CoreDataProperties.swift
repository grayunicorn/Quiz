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
  
  // a quiz is graded if every question has answers that can produce a grade - that is, if it has multiple choice
  // questions that can be automatically checked, and if any text answer has a grade recorded. The actual grade is
  // not recorded only the fact that a grade is possible. (Because a teacher could revise the correct answer and then
  // grades should be recalculated)
  func isGradeable() -> Bool {
    
    var gradeable = true;
    
    for question in questions! {
      let thisQuestion = question as! QuizQuestion

      // for now it is just assumed that since student quizzes come directly from teacher quizzes they always have
      // multiple choice answers that can be checked against teacher answers. Only text answers matter here.
      if thisQuestion.answers!.count == 0 {
        
        // default value is -1, so if a grade has not been assigned it is < 0
        if thisQuestion.assignedPercentage < 0 {
          // not assigned a grade - can't be graded
          gradeable = false
          break
        }
      }
    }
    return gradeable
  }
  
  // attempt to grade this quiz against a supplied quiz.
  // for each multiple choice question, if the supplied quiz has answers that match that question is correct.
  // for each textual answer (no multiple choice answers) check for a teacher grade.
  // If all answers can be checked in this way add the marks and calculate a percentage which can be returned.
  // If a question is unanswered (i.e. teacher has not graded the text answer) return nil.
  //
  // one big assumption here is that every question is worth the same, proportionally.
  // value returned is grade out of 100.
  func gradeAgainst(teacherQuiz: QuizCollection) throws -> Int? {
    
    var cumulativeScore: Int = 0
    var questionCount: Int = 0
    
    if isGradeable() == false {
      return nil
    }
    
    let numberOfQuestions = questions!.count
    for questionIndex in 0..<numberOfQuestions {
      let question = questions![questionIndex] as! QuizQuestion
      let teacherQuestion = teacherQuiz.questions![questionIndex] as! QuizQuestion
      let numberOfAnswers = question.answers!.count
      if numberOfAnswers == 0 {
        
        // award points assigned by teacher for this text question
        cumulativeScore += Int(question.assignedPercentage)
        
      } else {
        
        var thisQuestionScore = 100
        
        for answerIndex in 0..<numberOfAnswers {
          let answer = question.answers![answerIndex] as! QuizAnswer
          let teacherAnswer = teacherQuestion.answers![answerIndex] as! QuizAnswer
          if answer.isCorrect != teacherAnswer.isCorrect {
            thisQuestionScore = 0
          }
        }
        cumulativeScore += thisQuestionScore
      }
      questionCount += 1
    }
    // then the final grade is the average - rounding here (dividing using Int) is intentional
    let grade = cumulativeScore / questionCount
    return grade
  }
}

