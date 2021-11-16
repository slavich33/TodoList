//
//  HomeTasks.swift
//  ToDoList
//
//  Created by Slava on 05.07.2021.
//

import Foundation
import RealmSwift

class HomeTasks: Object {
    
    @Persisted var name: String = ""
   
    
    @Persisted var tasks = List<AddedTasks>()
    @Persisted var goals = List<GoalsTI>()
    @Persisted var remBD = List<RemBD>()
    @Persisted var remindTi = List<ReminderTI>()
}

protocol DetachableObject: AnyObject {
    func detached() -> Self
}

extension Object: DetachableObject {
    func detached() -> Self {
        let detached = type(of: self).init()
        for property in objectSchema.properties {
            guard let value = value(forKey: property.name) else { continue }
            if property.isArray == true {
                //Realm List property support
                let detachable = value as? DetachableObject
                detached.setValue(detachable?.detached(), forKey: property.name)
            } else if property.type == .object {
                //Realm Object property support
                let detachable = value as? DetachableObject
                detached.setValue(detachable?.detached(), forKey: property.name)
            } else {
                detached.setValue(value, forKey: property.name)
            }
        }
        return detached
    }
}

extension List: DetachableObject {
    func detached() -> List<Element> {
        let result = List<Element>()

        forEach {
            if let detachable = $0 as? DetachableObject {
                let detached = detachable.detached() as! Element
                result.append(detached)
            } else {
                result.append($0) //Primtives are pass by value; don't need to recreate
            }
        }

        return result
    }
    func toArray() -> [Element] {
        return Array(self.detached())
    }
}

extension Results {
    func toArray<T: Object>() -> [T] {
        var array = [T]()
        
        for i in 0 ..< self.count {
            if let result = self[i] as? T {
                array.append(result.detached())
            }
        }

        return array
    }
}

extension List {
    func toArray<T: Object>() -> [T] {
        var array = [T]()
        
        for i in 0 ..< self.count {
            if let result = self[i] as? T {
                array.append(result.detached())
            }
        }

        return array
    }
    
//    func toDict() -> RemDict {
//        var array = [RemDict]()
//
//        for i in List.init() {
//            array.append(i)
//        }
//
//
//    }
    
    func getArray<T: Object>(selectedType: T.Type) -> [T]{
            let realm = try! Realm()
        
            let object = realm.objects(selectedType)
            var array = [T]()
            for data in object {
               array.append(data)
           }
            return array
       }
}

