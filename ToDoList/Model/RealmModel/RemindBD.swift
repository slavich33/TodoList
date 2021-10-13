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
    @objc dynamic var number: Int = 0
    @objc dynamic var day: String = ""
    @objc dynamic var isSelected: Bool = false
     var items = List<RemBD>()

    var parentCategory = LinkingObjects(fromType: HomeTasks.self, property: "remBD")
    
//    override class func primaryKey() -> String? {
//              return "number"
//         }
}
//extension RemBD: Persistable {
//
//    
//    public convenience init(managedObject: RemDict) {
//        number = managedObject.number
//        day = managedObject.day
//        isSelected = managedObject.isSelected
//    }
//    func managedObject() -> RemBD {
//        var character = RemBD()
//        character.number = number
//        character.isSelected = isSelected
//        character.day = day
//        return character
//    }
//    
//    typealias ManagedObject = RemBD
//
//
//
//
//}

public final class WriteTransaction {
    public var items = List<Object>()
    private let realm: Realm
    internal init(realm: Realm) {
        self.realm = realm
    }
    func add<T: Persistable>(_ value: T) {
//                                    , item: RemBD) {
        let remDict = value.managedObject()
        realm.add(value.managedObject())
//        let cells = realm.objects(value.managedObject())
//       let homeT =  HomeTasks().remBD
//        homeT.append()
//        let rem = RemBD()
//        rem.items.append(item)
//        item.append(value)
    }
    public func append<T: Persistable>(_ value: T, item: List<RealmSwift.Object>) {
//         RemBD().items.append(item)
        item.append(objectsIn: [value.managedObject()])
    }
//    func append(items: List<RealmSwift.Object>, number: Int, day: String, isSelected: Bool) {
////         RemBD().items.append(item)
//        let rem = RemBD()
//         rem.number = number
//        rem.isSelected = isSelected
//        rem.day = day
//         rem.items.append(objectsIn: items)
//         realm.add(rem)
//
//    }
    func append1(items: List<RemBD>, number: Int, day: String, isSelected: Bool) {
//         RemBD().items.append(item)
        let rem = RemBD()
         rem.number = number
        rem.isSelected = isSelected
        rem.day = day
         items.append(rem)
//         realm.add(rem)
         
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
