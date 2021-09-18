//
//  AddedTasks.swift
//  ToDoList
//
//  Created by Slava on 05.07.2021.
//

import Foundation
import RealmSwift

class AddedTasks: Object {
  
    @objc dynamic var name: String = ""
    @objc dynamic var goals: String = ""
    
//    @objc dynamic var uniqueKey: String = "TaskName"
    var parentCategory = LinkingObjects(fromType: HomeTasks.self, property: "tasks")
    
//    override class func primaryKey() -> String? {
//              return "uniqueKey"
//         }
  
}
