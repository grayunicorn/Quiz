//
//  StudentResultsViewController.swift
//  Quiz
//
//  Created by Adam Eberbach on 12/9/17.
//  Copyright © 2017 Adam Eberbach. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class StudentResultsViewController: UIViewController {
  
  var moc: NSManagedObjectContext?
  var student: Student?
  var teacher: Teacher?
  var results: [QuizCollection] = []
  
  @IBOutlet weak var tableView: UITableView!
  
  // refresh table view whenever this view appears
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if let student = student, let name = student.login {
      self.navigationItem.title = name
    }
  }
}

// MARK:- UITableViewDelegate
extension StudentResultsViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    tableView.deselectRow(at: indexPath, animated: true)
  }
}

// MARK:- UITableViewDelegate
extension StudentResultsViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    guard let student = student, let teacher = teacher else { return UITableViewCell() }
    let teacherQuiz = teacher.quizzes?.firstObject as! QuizCollection
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "QuizGradedCell")!
    let quizzes = student.quizzes
    let quizCollection = quizzes![indexPath.row] as! QuizCollection
    
    do {
      let grade = try quizCollection.gradeAgainst(teacherQuiz: teacherQuiz)
      cell.textLabel?.text = teacherQuiz.text
      cell.detailTextLabel?.text = String(describing: grade!)
    } catch {
      print("Cannot compute a grade")
    }
    return cell
  }
  
  // for now there are always two sections. Could complicate things by not showing a second section when no marks to review
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

    // there is only one section
    guard let student = student else { return 0 }
    let quizzes = student.quizzes
    return quizzes!.count
  }
}

