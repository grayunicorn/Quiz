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
  
  @IBOutlet weak var usernameField: UITextField!
  
  
  @IBAction func proceedAction(_ sender: Any) {
  }
  
  @IBAction func usernameEditingDidEnd(_ sender: Any) {
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
