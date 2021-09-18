//
//  GoalsTI.swift
//  ToDoList
//
//  Created by Slava on 07.08.2021.
//

import Foundation
import RealmSwift

class GoalsTI: Object {
    
//    @objc dynamic var uniqueKey: String = "SelectedRow"
    @objc dynamic var rowNumber: Int = 0
    @objc dynamic var rowDesc: String = ""
    
    var parentCategory = LinkingObjects(fromType: HomeTasks.self, property: "goals")
    
//    override class func primaryKey() -> String? {
//              return "uniqueKey"
//         }
}
