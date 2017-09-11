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
    } else if let studentVC = segue.destination as? StudentViewController {
      studentVC.me = loggedInStudent
    } else {
      print("That can't happen - login type unknown")
    }
  }
  
  @IBAction func proceedButtonAction(_ sender: Any) {
    
    // can't match anything without characters or a context
    guard let loginAttempt = usernameField.text, loginAttempt.isEmpty == false else { return }
    guard let moc = moc else { return }
    
    // look for a teacher with this name
    let teachersRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Teacher.kManagedObjectIdentifier)
    let teachersNamePredicate = NSPredicate(format: "login == %@", loginAttempt)
    teachersRequest.predicate = teachersNamePredicate
    
    do {
      let teachers = try moc.fetch(teachersRequest) as! [Teacher]
      if let foundTeacher = teachers.first {
        
        loggedInTeacher = foundTeacher
        performSegue(withIdentifier: LoginViewController.kTeacherLoginSegue, sender: self)
        return
      }
    } catch {
      
    }
    
    // or, it could be a student
    // look for a teacher with this name
    let studentRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Student.kManagedObjectIdentifier)
    let studentNamePredicate = NSPredicate(format: "login == %@", loginAttempt)
    studentRequest.predicate = studentNamePredicate
    
    do {
      let students = try moc.fetch(studentRequest) as! [Student]
      if let foundStudent = students.first {
        
        loggedInStudent = foundStudent
        performSegue(withIdentifier: LoginViewController.kStudentLoginSegue, sender: self)
        return
      }
    } catch {
      
    }

  }
  
  @IBAction func usernameEditingDidEnd(_ sender: Any) {
    print("editDidEnd")
  }
  
  @IBAction func reset(_ sender: Any) {
    

    if let moc = moc {
      do {
        try ImportJSONData.importJSONUsersFrom("users", fileExt: "json", context: moc)
      } catch {
        print("File input error!")
      }

//      do {
//        try ImportJSONData.importJSONQuizFrom("question_data", fileExt: "json", teacher: defaultTeacher, context: moc)
//      } catch {
//        print("File input error!")
//      }
    }
  }
}

// MARK:- UITextFieldDelegate
extension LoginViewController {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    return true
  }

}
