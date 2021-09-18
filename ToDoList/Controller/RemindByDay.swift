//
//  RemindByDay.swift
//  ToDoList
//
//  Created by Slava on 21.07.2021.
//

import Foundation
import UIKit
import RealmSwift

protocol RemindBDProtocol {
    func textRemindBD(text: [String])
}



class RemindBD: UITableViewController {
    
    let realm = try! Realm()
    var cells: Results<RemBD>?
    public var delegate: RemindBDProtocol!
    let days = Days()
    let dataFile = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

    override func viewDidLoad() {
        super.viewDidLoad()

        calledOnce()
        loadItems()
 
    }
    
   
    
    //MARK: - Add Button
    
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    //MARK: - data manipulation methods

    func calledOnce(){
        struct Holder { static var called = false }

        if !Holder.called {
            Holder.called = true
            saveDay()
        }
    }
    
    func saveDay() {
        let realm = try! Realm()
        
        try! realm.write {
            let allDays = getDaysArray(array: days.days)
            
            for day in allDays {
                
                realm.add(day, update: .all)
            }
        }
        
        self.tableView.reloadData()
    }
    
    func getDaysArray(array: [String] ) -> [RemBD] {
        var requiredDays = [RemBD]()
        
        for (tag, n) in array.enumerated() {
            let day = RemBD()
            day.name = n
            day.uniqueKey = String(tag)
            requiredDays.append(day)
        }
        
        return requiredDays
    }
    
    func loadItems() {
        
        cells = realm.objects(RemBD.self).sorted(byKeyPath: "uniqueKey", ascending: true)
        
        self.tableView.reloadData()
        
    }
    
    
    
    //MARK: - TableView Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells?.count ?? 7
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let newItem = RemBD()
        newItem.name = days.days[indexPath.row]
        if let item = cells?[indexPath.row] {
            
            cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
            cell.textLabel?.text = item.name
            cell.accessoryType = item.done ? .checkmark : .none
            
        }
        
        return cell
        
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        
        if let item = cells?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                    
                }
            } catch {
                print("Error saving done, \(error)")
            }
        }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
        getNames()
        
    }
    
    func getNames() {
        
        let res =  realm.objects(RemBD.self).filter("done = true").sorted(byKeyPath: "uniqueKey", ascending: true)
        var arrayNames: [String] = []
        if arrayNames.isEmpty {
            
            self.delegate.textRemindBD(text: arrayNames)
        }
        
        for n in res {
            
            arrayNames.append(String(n.name.prefix(2)))
            self.delegate.textRemindBD(text: arrayNames)
            print(arrayNames)
            
        }
    }
    
}



//MARK: - Code examples

//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
//
//        if self.isBeingPresented || self.isMovingToParent {
//            // Perform an action that will only be done once
//                saveDay()
//                loadItems()
//           }

//        if realm.isEmpty {
//
//            saveDay()
//            loadItems()
//
//        } else {
//            loadItems()
//        }

//    }

//override func viewDidAppear(_ animated: Bool) {
//    super.viewDidAppear(true)
    
//        if isViewControllerVisited == false {
//            saveDay()
//            loadItems()
//            isViewControllerVisited = true
//        } else {
//            loadItems()
//        }
    
//        UserDefaults.standard.set(false, forKey: "isLoaded")
//
//          if UserDefaults.standard.bool(forKey: "isLoaded") == false {
//              UserDefaults.standard.set(true, forKey: "isLoaded")
//                saveDay()
//                loadItems()
//
//          } else {
//            loadItems()
//          }
//}

//        if daysdict[indexPath.row] != nil {
//            cell.accessoryType = daysdict[indexPath.row] ?? false ? .checkmark : .none
//        } else {
//            daysdict[indexPath.row] = false
//            cell.accessoryType = .none
//        }

//        do {
//        try UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: daysdict, requiringSecureCoding: false), forKey: "daysdict")
//        } catch {
//            print(error)
//        }
//        UserDefaults.standard.synchronize()
        
//        if let indexPath = tableView.indexPathForSelectedRow {
////
//
//            if dones {
//
//            }
//            if let item = cells?[indexPath.row] {
//                do {
//                    try realm.write {
//                        item.done = !item.done
//                    }
//                } catch {
//                    print("Error saving done, \(error)")
//                }
//            }
//
//            tableView.reloadData()

//            tableView.deselectRow(at: indexPath, animated: true)
