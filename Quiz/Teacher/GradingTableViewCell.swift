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

    // when the action fires and the slider changes the value, the label showing the grade should be updated
    // and at the same time this cell's delegate notified of the new value.
    gradeLabel.text = String(Int(sender.value))
    delegate?.gradeDidChange(grade: Int(sender.value))
  }
}
