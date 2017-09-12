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
// - student headings, with markers for available results or required assessments
// - statistics incuding average mark, most correct question, most incorrect etc.

class TeacherViewController: UIViewController {

  var me: Teacher?
  var moc: NSManagedObjectContext? = nil
  var selectedQuizCollection: QuizCollection?
  var selectedStudent: Student?

  @IBOutlet weak var tableView: UITableView!
  
  let kQuizSection = 0
  let kStudentSection = 1
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    if let quizVC = segue.destination as? QuizViewController {
      
      // go and edit a quiz
      quizVC.quizCollection = selectedQuizCollection
      quizVC.moc = moc!
      
    } else if let studentVC = segue.destination as? StudentResultsViewController {
      
      // display results with focus on the selected student
      studentVC.student = selectedStudent
      studentVC.teacher = me
      studentVC.moc = moc!

    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if let me = me, let name = me.login {
      self.navigationItem.title = name
    }
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
    } else if indexPath.section == kStudentSection {
      if let students = me.students {
        if let student = students[indexPath.row] as? Student {
          selectedStudent = student
          performSegue(withIdentifier: "TeacherStudentSegue", sender: self)
        }
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
    } else if section == kStudentSection {
      return "My Students"
    }
    return nil
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    var cell = UITableViewCell()
    guard let me = me, let quizzes = me.quizzes, let students = me.students else { return cell }

    if indexPath.section == kQuizSection {
      if let newCell = tableView.dequeueReusableCell(withIdentifier: "QuizTitleTableViewCell") {
        let quiz = quizzes[indexPath.row] as! QuizCollection
        newCell.textLabel?.text = quiz.text
        cell = newCell
      }
    } else if indexPath.section == kStudentSection {
      if let newCell = tableView.dequeueReusableCell(withIdentifier: "StudentNameTableViewCell") {
        let student = students[indexPath.row] as! Student
        newCell.textLabel?.text = student.login
        cell = newCell
      }
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    guard let me = me, let quizzes = me.quizzes, let students = me.students else { return 0 }
    
    var count = 0
    if section == kQuizSection {
      // return the count of quizzes for this teacher
      count = quizzes.count
    } else if section == kStudentSection {
      // return the count fo students for this teacher
      count = students.count
    }
    return count
  }
  
  // what could happen here is for the two section contants to become enums with value equal to the section number,
  // with the value returned by this function equal to the number of values in the enum.
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
}


