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

class StudentViewController: UIViewController {
  
  var me: Student?
  
  override func performSegue(withIdentifier identifier: String, sender: Any?) {

    // transition to a select teacher table
    // transition to a quiz completion view
  }
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    // find the teachers that this student has - one section per result
    // within each section there are as many rows as there are quizzes to attempt
  }
  
  
}
