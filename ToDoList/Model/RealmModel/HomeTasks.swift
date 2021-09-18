//
//  HomeTasks.swift
//  ToDoList
//
//  Created by Slava on 05.07.2021.
//

import Foundation
import RealmSwift

class HomeTasks: Object {
    
    @objc dynamic var name: String = ""
    
    let tasks = List<AddedTasks>()
    let goals = List<GoalsTI>()
}
