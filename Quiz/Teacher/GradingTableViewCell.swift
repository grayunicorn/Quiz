//
//  GradingTableViewCell.swift
//  Quiz
//
//  Created by Adam Eberbach on 13/9/17.
//  Copyright © 2017 Adam Eberbach. All rights reserved.
//

import Foundation
import UIKit

class GradingTableViewCell: UITableViewCell {
  
  @IBOutlet weak var slider: UISlider!
  @IBOutlet weak var gradeLabel: UILabel!
 
  var delegate: GradingValueDelegate?
  
  @IBAction func doSomething(sender: UISlider) {

    delegate?.gradeDidChange(grade: Int(sender.value))
    gradeLabel.text = String(Int(sender.value))
  }
}
