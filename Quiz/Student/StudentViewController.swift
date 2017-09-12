//
//  StudentViewController.swift
//  Quiz
//
//  Created by Adam Eberbach on 11/9/17.
//  Copyright © 2017 Adam Eberbach. All rights reserved.
//

import Foundation
import UIKit
import CoreData

// Student view controller.
// Most of the time a student has one teacher but could have two. There are as many
// sections in the student view as the student has teachers - in this canned example
// only Toby has two teachers. This could also be changed to be a per-subject view or
// there could be subject and teachers, courses, schools and other sort keys.
// When a student is logged in they should see the quizzes available from their teacher.
// The student can take the quiz by selecting it. There is also a section to view their results
// from previous attempts.

class StudentViewController: UIViewController {
  
  var me: Student?
  var teacher: Teacher?
  var moc: NSManagedObjectContext? = nil
  
  let kAvailableQuizSection = 0
  let kCompletedQuizSection = 1
  
  var selectedQuizCollection: QuizCollection?
  
  @IBOutlet weak var tableView: UITableView!
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if let quizVC = segue.destination as? QuizViewController {
      // go and do a quiz
      quizVC.quizCollection = selectedQuizCollection
      quizVC.moc = moc!
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    
    super.viewWillAppear(animated)
    tableView.reloadData()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if let me = me, let name = me.login {
      self.navigationItem.title = name
    }
  }
}

// MARK:- UITableViewDelegate
extension StudentViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    if indexPath.section == kAvailableQuizSection {
      
      // select the teacher's quiz for this row
      if let me = me, let teacher = me.teacher, let quizzes = teacher.quizzes {
        if let quizCollection = quizzes[indexPath.row] as? QuizCollection {
          
          do {
            if let duplicateQuizCollection = try quizCollection.duplicateWithoutAnswers(moc: moc!) {
              me.addToQuizzes(duplicateQuizCollection)
              selectedQuizCollection = duplicateQuizCollection
              performSegue(withIdentifier: "BeginQuizSegue", sender: self)
            }
          } catch {
            print("Can't duplicate the quiz collection!")
          }
        }
      }
    }
    
    // turn off selection
    tableView.deselectRow(at: indexPath, animated: true)
  }
}

// MARK:- UITableViewDelegate
extension StudentViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    
    if section == kAvailableQuizSection {
      return "Available Quizzes"
    } else if section == kCompletedQuizSection {
      return "Completed"
    }
    return nil
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    // In first section configure cells with all available quiz titles
    // In second section configure cells with completed quiz titles and any available score
    var cell: UITableViewCell?
    if indexPath.section == kAvailableQuizSection {
      cell = tableView.dequeueReusableCell(withIdentifier: "QuizTitleTableViewCell")!
      
      // display the teacher's quiz for this row
      if let me = me, let teacher = me.teacher, let quizzes = teacher.quizzes {
        let quizCollection = quizzes[indexPath.row] as! QuizCollection
        cell!.textLabel?.text = quizCollection.text!
      }

    } else if indexPath.section == kCompletedQuizSection {
      
      cell = tableView.dequeueReusableCell(withIdentifier: "QuizGradedCell")!

      guard let me = me, let teacher = me.teacher else { return UITableViewCell() }

      let teacherQuiz = teacher.quizzes?.firstObject as! QuizCollection
      
      // display my completed quiz for this row
      if let quizzes = me.quizzes {
        let quizCollection = quizzes[indexPath.row] as! QuizCollection
        if quizCollection.isGradeable() {
          do {
            let grade = try quizCollection.gradeAgainst(teacherQuiz: teacherQuiz)
            cell!.detailTextLabel?.text = String.init(describing: grade)
          } catch {
            print("Cannot compute a grade")
          }
        } else {
          cell!.detailTextLabel?.text = "Awaiting grade"
        }
        cell!.textLabel?.text = quizCollection.text!
      }
    }
    return cell!
  }
  
  // for now there are always two sections. Could complicate things by not showing a second section when no marks to review
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  
  // In first section find the number of quizzes available
  // In second section find the number of results
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    if section == kAvailableQuizSection {
      guard let me = me, let teacher = me.teacher, let quizzes = teacher.quizzes else { return 0 }
      return quizzes.count
    } else if section == kCompletedQuizSection {
      guard let me = me, let quizzes = me.quizzes else { return 0 }
      return quizzes.count
    }
    return 0
  }
}
