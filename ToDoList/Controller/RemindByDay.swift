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
    
    var arrayDelegate: getDict!
    var newCell = List<RemBD>()
    let realm = try! Realm()
    var cells: Results<RemBD>?
    public var delegate: RemindBDProtocol!
    let days = Days()
    var dict = [RemDict(number: 0, day: "Monday", isSelected: false),
                RemDict(number: 1, day: "Tuesday", isSelected: false),
                RemDict(number: 2, day: "Wednesday", isSelected: false),
                RemDict(number: 3, day: "Thuesday", isSelected: false),
                RemDict(number: 4, day: "Friday", isSelected: false),
                RemDict(number: 5, day: "Saturday", isSelected: false),
                RemDict(number: 6, day: "Sunday", isSelected: false)]

    let dataFile = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

    var createdRemBD: HomeTasks? {
        didSet {

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(createdRemBD)
//        calledOnce()
//        loadItems()
    }
    
   
    
    //MARK: - Add Button
    
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        

        if let currentCategory = createdRemBD {
            
            if currentCategory.remBD.first != nil {
                
                
                
                print("Rembd didn;t nil")
                
            }
            else {
                //                saveDay()
                //                loadItems()
                //                try! realm.write {
                //
                ////                    cells = realm.objects(RemBD.self).sorted(byKeyPath: "uniqueKey", ascending: true)
                //
                //
                //                    print(cells)
                //
                ////                    let newRem = RemBD()
                ////                    for rem in dict {
                ////                        newRem.done = rem.isSelected
                ////                        newRem.name = rem.day
                ////                        newRem.uniqueKey = rem.number
                //                        let newRem = RemBD()
                //                    for each in dict {
                //                        let newRem = RemBD()
                //                        newRem.done = each.isSelected
                //                        newRem.uniqueKey = each.number
                //                        newRem.name = each.day
                //                        newRem.items.append(newRem)
                //                    }
                //                    newRem.items.append(objectsIn: cells!)
                //                    }
                //                for di in dict {
                //                    let container = try! Container()
                //                    try! container.write { transaction in
                //
                ////                        transaction.add(di)
                //                        transaction.append(items: returnResults() )
                //
                //                    }
                //                }
                
//                for di in dict {
//                    
//                    let container = try! Container()
//                    try! container.write { transaction in
//
//                        transaction.append1(items: currentCategory.remBD, number: di.number, day: di.day, isSelected: di.isSelected)
//                        
//                    }
//                }
                
                
           
                if currentCategory.remBD.first != nil {
                    
                }
//                loadItems()
//                try! realm.write{
////                    currentCategory.remBD.append(objectsIn: cells!)
//                        let newRem = RemBD()
//                                     for each in dict {
////                                         let newRem = RemBD()
//                                         newRem.isSelected = each.isSelected
//                                         newRem.number = each.number
//                                         newRem.day = each.day
////                                         newRem.items.append(newRem)
//                                         currentCategory.remBD.append(newRem)
//                                     }
//
//
//                }
                
            }
            self.arrayDelegate.getArray(dict: dict)
            getNames()
        }


//        }
        
        
//        if let currentCategory = createdRemBD {
//            if let currentData = cells?[0] {
//                if currentData.name != "" {
//                    do {
//                        try self.realm.write {
//
//                            print("rewrite current goal")
//                            currentData.done = delegateRow
//
//
////                            for task in currentCategory.tasks {
////                                task.goals = delegateRow
////                            }
//
//                        }
//                    } catch  {
//                        print("Error saving message \(error) ")
//                    }
//                }
//            } else {
//                if  changedRow == "" {
//                    try! realm.write{
//                        let newRow = GoalsTI()
//                        newRow.rowDesc = delegateRow
//                        newRow.rowNumber = pickerRow
//                        currentCategory.goals.append(newRow)
//                        realm.add(newRow)
//                        print("create current goal and append to goals")
//                    }
//                }
//            }
//        }
        
       
        
        
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

            realm.add(allDays)
//            for day in allDays {
//                
//                realm.add(day)
////                          , update: .all)
//            }
        }
        
        self.tableView.reloadData()
    }
    
    func getDaysArray(array: [String] ) -> [RemBD] {
        var requiredDays = [RemBD]()
        
        for (tag, n) in array.enumerated() {
            let day = RemBD()
            day.day = n
            day.number = tag
            requiredDays.append(day)
        }
        
        return requiredDays
    }
    
    func loadItems() {
        

        if let currentCategory = createdRemBD?.remBD {
            if currentCategory.first != nil {
                cells = createdRemBD?.remBD.sorted(byKeyPath: "number", ascending: true)
                print("currentCategory.first != nil")
            } else {
                cells = realm.objects(RemBD.self).sorted(byKeyPath: "number", ascending: true)
                print("currentCategory.first = nil")
            }
    }
        
        self.tableView.reloadData()
        
    }
    func returnResults() -> Results<RemBD> {
        
        
        if let currentCategory = createdRemBD?.remBD {
            if currentCategory.first != nil {
                cells = createdRemBD?.remBD.sorted(byKeyPath: "number", ascending: true)
                print("currentCategory.first != nil")
            } else {
                cells = realm.objects(RemBD.self).sorted(byKeyPath: "number", ascending: true)
                print("currentCategory.first = nil")
            }
        }

        
        self.tableView.reloadData()
        return cells!
    }
    func loadDay() {
        
        var cel: Results<RemBD>?
        cel = createdRemBD?.remBD.sorted(byKeyPath: "number", ascending: true)
       
        cells = cel

        self.tableView.reloadData()
    }
    
    
    
    //MARK: - TableView Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dict.count
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let newItem = RemBD()
        newItem.day = days.days[indexPath.row]
        let week = dict[indexPath.row]

        if let item = cells?[indexPath.row] {
            cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
            cell.textLabel?.text = item.day
            cell.accessoryType = item.isSelected ? .checkmark : .none
            print("It's current item")
        }
            else {
            cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
            cell.textLabel?.text = week.day
            cell.accessoryType = week.isSelected ? .checkmark : .none
                print("It's current rem cells")
        }
        
       

        
        return cell
        
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        dict[indexPath.row].isSelected.toggle()
//        tableView.reloadRows(at: [indexPath], with: .none)
            
        
        if let item = cells?[indexPath.row] {
            do {
                try realm.write {
                    print("it's working add with current Accessory in cells")
//                    let item = RemBD()
//                    let newRem = RemBD()
//                    newRem.isSelected = !newRem.isSelected
//                    cells?[indexPath.row].isSelected = newRem.isSelected
//                    newRem.name = dict[indexPath.row].day
//                    newRem.done = dict[indexPath.row].isSelected
//                    newRem.uniqueKey = indexPath.row
                    item.isSelected = !item.isSelected
//                    realm.add(newRem)

                }
            } catch {
                print("Error saving done, \(error)")
            }
        } else {
            
//            dict[indexPath.row].isSelected = !dict[indexPath.row].isSelected
            print("it's working add with dict cells")
        }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
//        getNames()
        
    }
    
    func getNames() {
        
//        let res =  realm.objects(RemBD.self).filter("isSelected = true").sorted(byKeyPath: "number", ascending: true)
//        var arrayNames: [String] = []
//        if arrayNames.isEmpty {
//
//            self.delegate.textRemindBD(text: arrayNames)
//        }
//
//        for n in res {
//
//            arrayNames.append(String(n.day.prefix(2)))
//            self.delegate.textRemindBD(text: arrayNames)
//            print(arrayNames)
        
        let res =  createdRemBD?.remBD.filter("isSelected = true").sorted(byKeyPath: "number", ascending: true)
        var arrayNames: [String] = []
        if arrayNames.isEmpty {
            
            self.delegate.textRemindBD(text: arrayNames)
        }
        
        for n in res! {
            
            arrayNames.append(String(n.day.prefix(2)))
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
