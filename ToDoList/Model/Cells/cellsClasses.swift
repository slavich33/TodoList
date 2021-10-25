//
//  cells.swift
//  ToDoList
//
//  Created by Slava on 10.07.2021.
//

import Foundation
import UIKit
import RealmSwift
import SwipeCellKit

class homeCell: SwipeTableViewCell {
    
    
    @IBOutlet var homeLabel: UILabel!
    
}

protocol CustomCellDelegate {
    func reloadTable()
}
class tasking: UITableViewCell, UITextFieldDelegate {

    var delegate: CustomCellDelegate!
    
    @IBOutlet var tipsButton: UIButton!
    @IBOutlet var textField: UITextField!
//    @IBAction func textField(_ sender: UITextField) {
//        
//    }
    @IBOutlet var tipsLabel: UILabel!
  
    override func awakeFromNib() {
          super.awakeFromNib()

          textField.delegate = self
      }
    
//    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//           if textField.text != "" {
//               return true
//           } else {
//               textField.placeholder = "Type something"
//               return false
//
//           }
//
//       }
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        
//        let text = AddTask().selectedCellIdentifier
//       
//        if cellTips().cellArray.contains(text) {
//            textField.text = text
//            AddTask().homeTaskName = textField.text!
//            
//        } else {
//            textField.text = textField.text
//            AddTask().homeTaskName = textField.text!
//            
//        }
//        AddTask().homeTaskName = textField.text!
//        AddTask().selectedCellIdentifier = ""
//        print("\(AddTask().homeTaskName)")
//        delegate.reloadTable()
//        print("delegate edeting")
//    }
    
}


class remindByDay: UITableViewCell {
    
    @IBOutlet var remindLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    
}

class reminderTime: UITableViewCell {
    
    @IBOutlet var reminderLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
}

class goal: UITableViewCell {
    
    @IBOutlet var goalLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    
    
    var isSeparatorHidden: Bool {
        get {
            return self.separatorInset.right != 0
        }
        set {
            if newValue {
                self.separatorInset = UIEdgeInsets(top: 0, left: self.bounds.size.width, bottom: 0, right: 0)
            } else {
                self.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            }
        }
    }
    
}

class Tips {
    
    var sectionName: String?
    var cellName: [String]?
    
    init(sectionName: String, cellName: [String]) {
        self.sectionName = sectionName
        self.cellName = cellName
    }
    
}



struct Days {
    
    let days: [String] = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
}

struct cellTips {
    
    
    var cellArray = ["Working out", "Drink water", "Jogging", "Call doctor", "Go out with kids", "Gymnastics with child", "Pool with family", "Call to parents", "Learning new language", "Reading", "Meditation", "Go to gym", "Cleaning", "Go to market", "Cook a dinner", "Dissemble a closet"  ]
}

struct RemDict {
    
    public var number : Int
    public var day : String
    public var isSelected : Bool
   
    
//    var remBdDict = [0:"Monday", 1:"Tuesday", 2:"Wendsday", 3:"Thursday", 4:"Friday", 5:"Saturday", 6:"Sunday"]
    
}

extension RemDict: Persistable, Equatable {
    
    
    public init(managedObject: RemBD) {
        number = managedObject.number
        day = managedObject.day
        isSelected = managedObject.isSelected
        
        
        
    }
    public func managedObject() -> RemBD {
        let character = RemBD()
        character.number = number
        character.isSelected = isSelected
        character.day = day
        return character
    }
    
    
}

struct SegueKeys {
    
    var goToTips = "goToTaskName-tips"
    var goToRemindByDay = "goToRemindByDay"
    var goToReminderTime = "goToRemindTime"
    var goToGoal = "goToGoal"
}
