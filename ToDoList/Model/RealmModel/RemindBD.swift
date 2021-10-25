//
//  RemindBD.swift
//  ToDoList
//
//  Created by Slava on 03.08.2021.
//

import Foundation
import RealmSwift

public protocol Persistable {
    associatedtype ManagedObject: RealmSwift.Object
    init(managedObject: ManagedObject)
    func managedObject() -> ManagedObject
}


class RemBD: Object {
    

//    @objc dynamic var uniqueKey: Int = 0
    @Persisted var number: Int = 0
    @Persisted var day: String = ""
    @Persisted var isSelected: Bool = false
     var items = List<RemBD>()

    var parentCategory = LinkingObjects(fromType: HomeTasks.self, property: "remBD")
//    var parentCategory1 = LinkingObjects(fromType:  AddedTasks.self, property: "remBD")

}
public final class WriteTransaction {
    public var items = List<Object>()
    private let realm: Realm
    internal init(realm: Realm) {
        self.realm = realm
    }
    func add<T: Persistable>(_ value: T) {
        realm.add(value.managedObject())
    }
    public func append<T: Persistable>(_ value: T, item: List<RealmSwift.Object>) {
        item.append(objectsIn: [value.managedObject()])
    }

    func append1(items: List<RemBD>, number: Int, day: String, isSelected: Bool) {
        let rem = RemBD()
         rem.number = number
        rem.isSelected = isSelected
        rem.day = day
         items.append(rem)
    }
}
// Implement the Container
public final class Container {
    private let realm: Realm
    public convenience init() throws {
        try self.init(realm: Realm())
    }
    internal init(realm: Realm) {
        self.realm = realm
    }
    public func write(_ block: (WriteTransaction) throws -> Void)
    throws {
        let transaction = WriteTransaction(realm: realm)
        try realm.write {
            try block(transaction)
        }
        
    }
}

