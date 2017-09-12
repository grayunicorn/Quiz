//
//  LoginViewController.swift
//  Quiz
//
//  Created by Adam Eberbach on 10/9/17.
//  Copyright © 2017 Adam Eberbach. All rights reserved.
//

// Accept a username entered in a text field and begin the application if possible.
// If the username is unknown say so.

import UIKit
import CoreData

class LoginViewController: UIViewController {
  
  var moc: NSManagedObjectContext? = nil
  var loggedInTeacher: Teacher?
  var loggedInStudent: Student?
  
  static let kTeacherLoginSegue = "TeacherLoginSegue"
  static let kStudentLoginSegue = "StudentLoginSegue"

  @IBOutlet weak var usernameField: UITextField!
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if let teacherVC = segue.destination as? TeacherViewController {
      teacherVC.me = loggedInTeacher
      teacherVC.moc = moc
    } else if let studentVC = segue.destination as? StudentViewController {
      studentVC.me = loggedInStudent
      studentVC.moc = moc
    } else {
      print("That can't happen - login type unknown")
    }
  }
  
  @IBAction func proceedButtonAction(_ sender: Any) {
    
    // can't match anything without characters or a context
    guard let loginAttempt = usernameField.text, loginAttempt.isEmpty == false else { return }
    guard let moc = moc else { return }
    var recognised = false
    
    // Core data search for a teacher with this name
    let teachersRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Teacher.kManagedObjectIdentifier)
    let teachersNamePredicate = NSPredicate(format: "login == %@", loginAttempt)
    teachersRequest.predicate = teachersNamePredicate
    
    do {
      let teachers = try moc.fetch(teachersRequest) as! [Teacher]
      if let foundTeacher = teachers.first {
        // teacher login recognised, proceed as teacher
        loggedInTeacher = foundTeacher
        performSegue(withIdentifier: LoginViewController.kTeacherLoginSegue, sender: self)
        recognised = true
      }
    } catch {
      print("could not look up teacher")
    }
    
    if recognised == false {
      // if not a teacher, Core data search for a student with this name
      let studentRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Student.kManagedObjectIdentifier)
      let studentNamePredicate = NSPredicate(format: "login == %@", loginAttempt)
      studentRequest.predicate = studentNamePredicate
      
      do {
        let students = try moc.fetch(studentRequest) as! [Student]
        if let foundStudent = students.first {
          
          loggedInStudent = foundStudent
          performSegue(withIdentifier: LoginViewController.kStudentLoginSegue, sender: self)
          recognised = true
        }
      } catch {
        print("could not look up student")
      }
    }
    
    if recognised == false {
      // if a student was not found either then a simple alert if the login is not recognized
      let alertController = UIAlertController(title: "Login Failure", message: "Login was not recognised.", preferredStyle: .alert)
      let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
      alertController.addAction(defaultAction)
      present(alertController, animated: true, completion: nil)
    }
  }
}

// MARK:- UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    proceedButtonAction(textField)
    return true
  }
}
