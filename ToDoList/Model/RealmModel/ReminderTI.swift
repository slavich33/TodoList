//
//  ReminderTI.swift
//  ToDoList
//
//  Created by Slava on 18.08.2021.
//

import Foundation
import RealmSwift

class ReminderTI: Object {
    
    @objc dynamic var date: String = ""
    @objc dynamic var uniqueKey: String = "SelectedTime"
    
    override class func primaryKey() -> String? {
              return "uniqueKey"
         }
}
