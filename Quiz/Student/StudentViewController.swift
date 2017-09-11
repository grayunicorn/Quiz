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
  var myTeacher: Teacher?
  
  @IBOutlet weak var tableView: UITableView!
  
  override func performSegue(withIdentifier identifier: String, sender: Any?) {
    
    // transition to a select teacher table
    // transition to a quiz completion view
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
    
    // find the teachers that this student has - one section per result
    // within each section there are as many rows as there are quizzes to attempt
    print("selected index row \(indexPath)")
    performSegue(withIdentifier: "", sender: self)
    tableView.deselectRow(at: indexPath, animated: true)
  }
}

// MARK:- UITableViewDelegate
extension StudentViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
  
    if section == 1 {
      return "Available Quizzes"
    } else if section == 2 {
      return "Completed"
    }
    return nil
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    // In first section configure cells with all available quiz titles
    // In second section configure cells with completed quiz titles and any available score
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "QuizTitleTableViewCell")
    if indexPath.section == 1 {
      
      // display the teacher's quiz for this row
      if let me = me, let teacher = me.teacher, let quizzes = teacher.quizzes {
        let quizCollection = quizzes[indexPath.row] as! QuizCollection
        cell!.textLabel?.text = quizCollection.text!
      }
      
    } else if indexPath.section == 2 {
      
      // display my completed quiz for this row
      if let me = me, let quizzes = me.quizzes {
        let quizCollection = quizzes[indexPath.row] as! QuizCollection
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
    
    if section == 1 {
      guard let me = me, let teacher = me.teacher, let quizzes = teacher.quizzes else { return 0 }
      return quizzes.count
    } else if section == 2 {
      guard let me = me, let quizzes = me.quizzes else { return 0 }
      return quizzes.count
    }
    return 0
  }
}
