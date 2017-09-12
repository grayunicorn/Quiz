//
//  TeacherViewController.swift
//  Quiz
//
//  Created by Adam Eberbach on 11/9/17.
//  Copyright © 2017 Adam Eberbach. All rights reserved.
//

import Foundation
import UIKit
import CoreData

// the Teacher view controller should present the Teacher's view as a table
// 1. quizzes that this teacher can set answers for (used in automatic grading)
// 2. quizzes that this teacehr needs to manually mark, as written by students (i.e. text questions)
// 3. students that can be viewed (leading to results)

class TeacherViewController: UIViewController {

  var me: Teacher?
  var moc: NSManagedObjectContext? = nil
  var selectedQuizCollection: QuizCollection?
  var selectedStudent: Student?
  var grading = false
  
  // these two arrays are used for precalculation of table view display
  var needGrading: [QuizCollection]?
  var haveResults: [Student]?
  
  @IBOutlet weak var tableView: UITableView!
  
  let kQuizSection = 0
  let kCorrectionSection = 1
  let kResultsSection = 2
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    if let studentResultsVC = segue.destination as? StudentResultsViewController {
      studentResultsVC.teacher = me
      studentResultsVC.student = selectedStudent
      
    } else if let quizVC = segue.destination as? QuizViewController {

      // go and edit a quiz
      quizVC.quizCollection = selectedQuizCollection
      if grading == true {
        quizVC.gradingView = true
      }
      quizVC.moc = moc!
    }
  }

  // refresh table view whenever this view appears
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    prepareTableView()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if let me = me, let name = me.login {
      self.navigationItem.title = name
    }
  }
  
  // gather the information to get this table view displayed correctly and reload data
  func prepareTableView() {

    guard let me = me else { return }
    
    grading = false
    
    // empty the arrays
    needGrading = []
    haveResults = []
    
    // gather every quiz that is completed by a student and requires Teacher grading
    if let students = me.students {
      for student in students {
        let student = student as! Student
        needGrading?.append(contentsOf: student.quizzesRequiringGrading())
        let completeQuizzes = student.gradeableResults()
        if completeQuizzes.count > 0 {
          // gather each student that has results that can be viewed
          haveResults?.append(student)
        }
      }
    }
    // cause refresh of the table view
    tableView.reloadData()
  }
}

// MARK:- UITableViewDelegate
extension TeacherViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    guard let me = me else { return }
    
    if indexPath.section == kQuizSection {
      
      // select the teacher's quiz for this row
      if let quizzes = me.quizzes {
        if let quizCollection = quizzes[indexPath.row] as? QuizCollection {
          
          // go to the quiz screen where the teacher can edit answers
          selectedQuizCollection = quizCollection
          performSegue(withIdentifier: "TeacherQuizSegue", sender: self)
        }
      }
    } else if indexPath.section == kCorrectionSection {

      // go to the quiz screen where the teacher can edit answers
      if let needGrading = needGrading {
        selectedQuizCollection = needGrading[indexPath.row]
        grading = true
        performSegue(withIdentifier: "TeacherQuizSegue", sender: self)
      }
      
    } else if indexPath.section == kResultsSection {
      
      if let haveResults = haveResults {
        selectedStudent = haveResults[indexPath.row]
        performSegue(withIdentifier: "TeacherStudentResultsSegue", sender: self)
      }
    }
    tableView.deselectRow(at: indexPath, animated: true)
  }
}

// MARK:- UITableViewDataSource
extension TeacherViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    
    if section == kQuizSection {
      return "My Quizzes"
    } else if section == kCorrectionSection {
      return "Grading Required"
    } else if section == kResultsSection {
      return "Results"
    }
    return nil
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    var cell = UITableViewCell()
    guard let me = me, let quizzes = me.quizzes, let students = me.students else { return cell }

    if indexPath.section == kQuizSection {
      // populate the cell with this Teacher's quiz at the index path
      if let newCell = tableView.dequeueReusableCell(withIdentifier: "QuizTitleTableViewCell") {
        let quiz = quizzes[indexPath.row] as! QuizCollection
        newCell.textLabel?.text = quiz.text
        cell = newCell
      }
    } else if indexPath.section == kCorrectionSection {
      
      // populate the cell with the quiz the Teacher should correct at the index path
      if let newCell = tableView.dequeueReusableCell(withIdentifier: "QuizTitleTableViewCell") {
        if let needGrading = needGrading {
          let quiz = needGrading[indexPath.row]
          newCell.textLabel?.text = quiz.text
        }
        cell = newCell
      }

    } else if indexPath.section == kResultsSection {
      
      // populate the cell with the student whose results can be viewed
      if let newCell = tableView.dequeueReusableCell(withIdentifier: "StudentNameTableViewCell") {
        if let haveResults = haveResults {
          let student = haveResults[indexPath.row]
          newCell.textLabel?.text = student.login
        }
        cell = newCell

        
        let student = students[indexPath.row] as! Student
        newCell.textLabel?.text = student.login
        cell = newCell
      }
    }
    return cell
  }
  
  // for each of the possible sections calculate how many rows are required
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    guard let me = me, let quizzes = me.quizzes else { return 0 }
    
    var count = 0
    if section == kQuizSection {
      
      // return the count of quizzes for this teacher
      count = quizzes.count
      
    } else if section == kCorrectionSection {

      if let needGrading = needGrading {
        count = needGrading.count
      }

    } else if section == kResultsSection {
      
      if let haveResults = haveResults {
        count = haveResults.count
      }
    }
    return count
  }
  
  // what could happen here is for the two section contants to become enums with value equal to the section number,
  // with the value returned by this function equal to the number of values in the enum.
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 3
  }
}


