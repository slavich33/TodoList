//
//  RemindBD.swift
//  ToDoList
//
//  Created by Slava on 03.08.2021.
//

import Foundation
import RealmSwift

class RemBD: Object {
    

    @objc dynamic var uniqueKey: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var done: Bool = false

    override class func primaryKey() -> String? {
              return "uniqueKey"
         }
}
