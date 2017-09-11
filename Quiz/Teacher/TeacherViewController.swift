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

  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    // transition to selected student summary table
    // transition to statistics view
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
}
