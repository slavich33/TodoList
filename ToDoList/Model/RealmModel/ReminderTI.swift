//
//  ReminderTI.swift
//  ToDoList
//
//  Created by Slava on 18.08.2021.
//

import Foundation
import RealmSwift

class ReminderTI: Object {
    
    @Persisted var date: String = ""
//    @Persisted var uniqueKey: String = "SelectedTime"
    
    var parentCategory = LinkingObjects(fromType: HomeTasks.self, property: "remindTi")
    
//    override class func primaryKey() -> String? {
//              return "uniqueKey"
//         }
}
