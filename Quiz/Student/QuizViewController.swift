//
//  QuizViewController.swift
//  Quiz
//
//  Created by Adam Eberbach on 11/9/17.
//  Copyright © 2017 Adam Eberbach. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class QuizViewController: UIViewController {
  
  var moc: NSManagedObjectContext?
  var quizCollection: QuizCollection?
  
  let kQuestionCellRow = 0
  
  // this is zero-based because it is used as index into the ordered sets of the core data objects
  var questionNumber = 0
  
  @IBOutlet weak var tableView: UITableView!
}

// MARK:- UITableViewDelegate
extension QuizViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    guard let quizCollection = quizCollection else { return }
    
    let finalRow = rowCount() - 1
    if indexPath.row == finalRow {
      // then this answer is submitted and the quiz should proceed
      questionNumber += 1
      if let _ = quizCollection.questionNumber(questionNumber) {
        // refresh the view for the next question
        tableView.reloadData()
      } else {
        // questions are all finished - write it to the student and navigate back
        do {
          moc!.insert(quizCollection)
          try moc!.save()
          navigationController?.popViewController(animated: true)
        } catch {
          print("Can't write a new submitted quiz for the student!")
        }
      }
    } else {
      // toggle the value of this answer
      if let thisQuestion = quizCollection.questionNumber(questionNumber), let answer = thisQuestion.answerNumber(indexPath.row - 1) {
        answer.isCorrect = !answer.isCorrect
        tableView.reloadData()
      }
    }
    
    // turn off selection
    tableView.deselectRow(at: indexPath, animated: true)
  }
}

// MARK:- UITableViewDelegate
extension QuizViewController: UITableViewDataSource {

  // this function handles a lot of exclusive possibilities
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    guard let quizCollection = quizCollection, let thisQuestion = quizCollection.questionNumber(questionNumber), let answers = thisQuestion.answers else { return UITableViewCell() }
    
    let finalRow = rowCount() - 1
    
    var cell = UITableViewCell()
    
    if indexPath.row == 0 {
      
      // this is the question cell
      cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell")!
      // the question forms its text
      cell.textLabel?.text = thisQuestion.text!
      
    } else if indexPath.row == finalRow {
      
      // this is the final submit cell which always keeps its set label
      cell = tableView.dequeueReusableCell(withIdentifier: "SubmitCell")!
      
    } else if finalRow == 2 && indexPath.row == 1 {
      
      // then this is a text-only answer - 3 cells total and this is the text cell - user can enter text freely to answer
      cell = tableView.dequeueReusableCell(withIdentifier: "TextInputCell")!

    } else {
      
      // all other possbilities are a regular multiple-choice answer cell, toggles true or false
      cell = tableView.dequeueReusableCell(withIdentifier: "MultipleChoiceCell")!
      let answerNumber = indexPath.row - 1
      let answer = answers[answerNumber] as! QuizAnswer
      cell.textLabel?.text = answer.text!
      
      if answer.isCorrect {
        cell.detailTextLabel?.text = "true"
        cell.detailTextLabel?.textColor = UIColor.green
      } else {
        cell.detailTextLabel?.text = "false"
        cell.detailTextLabel?.textColor = UIColor.red
      }
    }
    return cell
  }
  
  // there is only one section here
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  

  // calculate the number of cells to display without reference to index paths or table views, only the current question
  func rowCount() -> Int {
    
    guard let quizCollection = quizCollection else { return 0 }
    guard let thisQuestion = quizCollection.questionNumber(questionNumber) else { return 0 }
    guard let answers = thisQuestion.answers else { return 0 }
    
    // guard let quizCollection = quizCollection, let thisQuestion = quizCollection.questionNumber(questionNumber), let answers = thisQuestion.answers else { return 0 }
    
    // every question table has a question cell and a submit cell
    var cells = 2
    
    // It's a reasonable assumption to say that any value <= 1 means a textual answer with a single cell for a text field
    // (there can't be a multiple choice question with one answer)
    if answers.count <= 1 {
      cells += 1
    } else {
      // in this case there are at least two answers, for four cells minimum (including question and submit)
      cells += answers.count
    }
    return cells
  }
  
  // report the number of cells to be displayed for the current question
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return rowCount()
  }
}

