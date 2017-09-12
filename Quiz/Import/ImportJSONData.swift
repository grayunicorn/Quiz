//
//  ImportJSONData.swift
//  Quiz
//
//  Created by Adam Eberbach on 10/9/17.
//  Copyright © 2017 Adam Eberbach. All rights reserved.
//

import Foundation
import CoreData

class ImportJSONData {
  
  static let kTitleKey = "title"
  static let kQuestionsKey = "questions"
  static let kTeachersKey = "teachers"
  
  // import the JSON user data into core data
  class func importJSONUsersFrom(_ filePrefix: String, fileExt: String, context: NSManagedObjectContext?) throws {
    
    // cannot proceed if context is not valid or file does not exist
    guard let moc = context, let jsonFile = Bundle.main.url(forResource: filePrefix, withExtension: fileExt) else { return }
    
    let data = try Data(contentsOf: jsonFile)
    let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
    
    // cannot proceed if the JSON does not contain a dictionary
    guard let teachersArray = jsonObject as? [[String: Any]] else { return }
    // the teacher array contains a number of teachers with associated students
    for teacher in teachersArray {
      if let teacherName = teacher.keys.first {
        // create valid teacher names
        let newTeacher = Teacher.createWithLogin(login: teacherName, inContext: moc)
        
        if let studentArray = teacher[teacherName] as? [String] {
          // create valid student names for the teacher
          for studentName in studentArray {
            
            let newStudent = Student.createWithLogin(login: studentName, inContext: moc)
            moc.insert(newStudent)
            newTeacher.addToStudents(newStudent)
            newStudent.teacher = newTeacher
          }
        }
        // write the new User records to the managed object context
        moc.insert(newTeacher)
      }
    }
    try moc.save()
  }

  // import the JSON quiz data into core data and add it to a teacher's collection.
  class func importJSONQuizFrom(_ filePrefix: String, fileExt: String, teacher: Teacher, context: NSManagedObjectContext?) throws {
    
    // cannot proceed if context is not valid or file does not exist
    guard let moc = context, let jsonFile = Bundle.main.url(forResource: filePrefix, withExtension: fileExt) else { return }
    
    let data = try Data(contentsOf: jsonFile)
    let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
    
    // cannot proceed if the JSON does not contain a dictionary
    guard let questionDictionary = jsonObject as? [String: Any] else { return }

    // must be able to find a title for a new quiz collection
    guard let quizTitle = questionDictionary[kTitleKey] as? String else { return }
    
    // this is a new QuizCollection owned by the teacher (passed in)
    let newCollection = QuizCollection.createWithTitle(quizTitle, inContext: moc)
    teacher.addToQuizzes(newCollection)

    // the dictionary of questions has an array of dictionaries defining the questions
    if let questionsArray = questionDictionary[kQuestionsKey] as? [[String: [Any]]] {
      
      for question in questionsArray {

        // each question must have valid text to create the new QuizQuestion
        if let questionKey = question.keys.first {

          let newQuestion = QuizQuestion.createWithText(text: questionKey, inContext: moc)
          // value -1 is used to denote unset; normal range is 0-100 (percentage)
          newQuestion.assignedPercentage = -1
          newCollection.addToQuestions(newQuestion)
          
          // All questions have an answer array even if empty
          if let answers = question[questionKey] as? [[String: String]] {

            // if there are answers, create them and add them to the question
            if answers.count != 0 {
              for answer in answers {
                // the answer text is the text displayed with the answer but is also the key to the T or F indication
                if let answerText = answer.keys.first {
                    let newAnswer = QuizAnswer.createWithText(text: answerText, isCorrect: answer[answerText], inContext: moc)
                    newQuestion.addToAnswers(newAnswer)
                }
              }
            }
          }
        }
      }
    }
    // write the new QuizCollection to the managed object context
    moc.insert(newCollection)
    try moc.save()
  }
}
