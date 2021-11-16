//
//  AddTask.swift
//  ToDoList
//
//  Created by Slava on 04.07.2021.
//

import Foundation
import UIKit
import RealmSwift
import SwipeCellKit

protocol tableViewReload {
    func reload()
}

protocol getDict {
    
    func getArray(dict: [RemDict])
    
}

class AddTask: UITableViewController {
    
    var daysToRead = ""
    var taskingLabels = tasking()
    let realm = try! Realm()
    var addedTasks: Results<AddedTasks>?
    var selectedCellIdentifier: String = ""
    var remindBDArray: [String] = ["No"]
    var segues = SegueKeys()
    var reminderTime = "No"

    var goals = "Unlimited"
    var loaded: Bool = false
    var homeTaskName = ""
    var delegate: tableViewReload!
    var loadedData = true
    var equalRemBD = RemDict(managedObject: RemBD())
    var equatDelegate : getArray!
    var copiedRList = List<RemBD>()
    var arrayFromRemBD: [RemDict]?
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
        print("Name of the Tips will be: \(selectedCellIdentifier)")
        print("Name of the homeTask will be: \(homeTaskName)")
        print("Name of the current goals will be: \(goals)")
    }
    
    var createdTask: HomeTasks? {
        didSet {
            loadTasks()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        taskingLabels.tipsLabel?.text = "Hello"
        navigationItem.backBarButtonItem?.isEnabled = false
        setupHideKeyboardOnTap()
        tasking().textField?.delegate = self
        self.tableView.rowHeight = 44
        print("current Added tasks \(String(describing: addedTasks))")
        print("yey \(goals)")
        print("\(daysToRead)")
    }

    //MARK: - TableVIew Data source Methods

    func reloadTable() {
        tableView.reloadData()
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "tasking") as! tasking
            
            textFieldDidEndEditing(cell.textField)
            cell.textField.delegate = self
            
            return cell
            
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "remindByDay") as! remindByDay
            
            
            if daysToRead == "" {
                let rmbdString = remindBDArray.joined(separator: " ")
                
                cell.timeLabel?.text = rmbdString
            } else {
                cell.timeLabel?.text = daysToRead
            }
            
            return cell
            
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "reminderTime") as! reminderTime
            
            if reminderTime == "No" {
                cell.timeLabel.text = "No"
            } else {
                cell.timeLabel.text = reminderTime
            }
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "goal") as! goal
            
            cell.timeLabel.text = goals
            
            return cell
        }
    }
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            self.performSegue(withIdentifier: segues.goToTips, sender: indexPath)
        } else if indexPath.row == 1 {
            self.performSegue(withIdentifier: segues.goToRemindByDay, sender: indexPath)
        } else if indexPath.row == 2 {
            self.performSegue(withIdentifier: segues.goToReminderTime, sender: indexPath)
        } else if indexPath.row == 3 {
            self.performSegue(withIdentifier: segues.goToGoal, sender: indexPath)
        }
    }
    //MARK: - addNew Tips
    
    @IBAction func tipsBut(_ sender: UIButton) {
        
        performSegue(withIdentifier: segues.goToTips, sender: self)
        
    }
    func toDict(items: List<RemBD>) ->[RemDict] {
        
        var arDict = [RemDict]()
        for d in items {
            let dict = RemDict(managedObject: d)
            arDict.append(dict)
            
        }
        return arDict
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == segues.goToTips {
            
            let destinationVC = segue.destination as! TaskTips
            
            destinationVC.reloadDelegate = self
            destinationVC.delegate = self
            
            if selectedCellIdentifier != "" {
                destinationVC.selectedCellValue = selectedCellIdentifier
                tableView.reloadData()
            }
            
            
        } else if segue.identifier == segues.goToRemindByDay {
            
            let destinationVC = segue.destination as! RemindBD
            
            destinationVC.delegate = self
            destinationVC.arrayDelegate = self
            
            
            if let currentCategory = createdTask {
                
                destinationVC.createdRemBD = currentCategory
                
                if let currentData = addedTasks?[0] {
                    if currentData.readDays != ""  {
                        if arrayFromRemBD != nil {
                            destinationVC.dict = arrayFromRemBD!
                        } else {
                            destinationVC.dict = toDict(items: currentCategory.remBD)
                        }
                        
                        if destinationVC.createdRemBD?.remBD.first != nil {
                            destinationVC.loadDay()
                        }
                        print("destination didn't nill")
                        print("try to load goals ti")
                    }
                } else {
                    
                    if arrayFromRemBD != nil {
                        destinationVC.dict = arrayFromRemBD!
                    }
                    
                    if destinationVC.createdRemBD?.remBD.first != nil {
                        
                        destinationVC.loadItems()
                        print("destination didn't nill")
                    } else {
                        
                        print("just go to create rows")
                    }
                }
            }
            
            
        } else if segue.identifier == segues.goToReminderTime {
            
            let destinationVC = segue.destination as! RemindTi
            
            destinationVC.delegate = self
           
            if let currentCategory = createdTask {
                
                destinationVC.createdTime = currentCategory
                
                if  let currentData = addedTasks?[0] {
                    
                    
                    
                        if reminderTime == "No" {
//                            for date in currentCategory.remindTi {
//                                reminderTime = date.date
//                            }
                            destinationVC.currentDate = reminderTime
                        } else {
                            destinationVC.currentDate = reminderTime
//                            destinationVC.dict = toDict(items: currentCategory.remBD)
                        }
                        
//                        if destinationVC.createdTime?.remindTi.first != nil {
////                            destinationVC.loadDay()
//                            destinationVC.currentDate = reminderTime
//                        }
                        print("destination didn't nill")
                        print("try to load goals ti")
                    
                } else {
                    
                    if reminderTime != "No" {
                        destinationVC.currentDate = reminderTime
                    }
                    
//                    if destinationVC.createdTime?.remindTi.first != nil {
////                            destinationVC.loadDay()
//                        destinationVC.currentDate = reminderTime
//                        print("destination didn't nill")
//                    } else {
//
//                        print("just go to create rows")
//                    }
                }
                
//                if reminderTime == "No" {
//
//                }
                
//                if let currentData = addedTasks?[0] {
//                    
//                    for ti in currentCategory.remindTi {
//                        destinationVC.currentDate = ti.date
//                    }
//                    
//                }
               

            }
            
        } else if segue.identifier == segues.goToGoal {
            
            let destinationVC = segue.destination as! Goals
            
            destinationVC.delegate = self
            
            if let currentCategory = createdTask {
                
                destinationVC.createdRow = currentCategory
                
                if let currentData = addedTasks?[0] {
                    if currentData.goals != ""  {

                        destinationVC.delegateRow = goals
                        
                        if destinationVC.createdRow?.goals.first != nil {
                            destinationVC.changedRow = goals
                            destinationVC.loadRows()
                            print("destination didn't nill")
                        }
                        
                        print("try to load goals ti")
                    }
                } else {
                    
                    if destinationVC.createdRow?.goals.first != nil {
                        destinationVC.loadRows()
                        print("destination didn't nill")
                    }
                    print("just go to create rows")
                }
            }
        }
    }
    //MARK: - Add New Tasks
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        
        if let currentCategory = createdTask {
            print("\(currentCategory)")
            print("\(homeTaskName) goes to create current category")
            if let currentData = addedTasks?[0] {
                if currentData.name != "" {
                    do {
                        try self.realm.write {
                            
                            currentCategory.name = homeTaskName
//                            currentCategory.arrayDays = daysToRead
                            currentData.name = homeTaskName
                            currentData.goals = goals
                            currentData.readDays = daysToRead
                            currentData.reminderTime = reminderTime
                            currentCategory.remindTi.first?.date = reminderTime
                            
                        }
                    } catch  {
                        print("Error saving message \(error) ")
                    }
                }
                
            } else {
                
                if homeTaskName != "" {
                    print(createdTask!)
                    do {
                        try self.realm.write {
                            print("Trying to create addedTask")
                            let newTask = AddedTasks()
                            newTask.name = homeTaskName
                            newTask.goals = goals
                            newTask.readDays = daysToRead
                            newTask.reminderTime = reminderTime
                            let newGoal = GoalsTI()
                            newGoal.rowNumber = Int(goals) ?? 0
                            
                            self.equatDelegate.getArr(dict: copiedRList)
                            
                            currentCategory.tasks.append(newTask)
                            
                            let predicate = NSPredicate(format: "goals.@count > 0")
                            let filteredRes = realm.objects(HomeTasks.self).filter(predicate)
                            if filteredRes.count <= 0 {
                                print("performing created object in goalsTI")
                                currentCategory.goals.append(newGoal)
                            }
                            else {
                                print("GolasTI were added before")
                            }
                            
                            let newTI = ReminderTI()
                            newTI.date = reminderTime
                            currentCategory.remindTi.append(newTI)
                            
                            currentCategory.name = homeTaskName
//                            currentCategory.arrayDays = daysToRead
//                            currentCategory.remTi = reminderTime
                        }
                    } catch  {
                        print("Error saving message \(error) ")
                    }
                }
            }
            
            if arrayFromRemBD != nil {
                writeArray(dict: arrayFromRemBD!)
            }
            
            if currentCategory.name == "" {
                for goal in currentCategory.goals {
                    if goal.rowDesc != "" {
                        print("Deleting current GoalsTI")
                        try! self.realm.write {
                            realm.delete(currentCategory.goals)
                        }
                    }
                }
            }
        }
        
        self.delegate.reload()
        dismiss(animated: true)
        
    }
    //MARK: - data manipulation methods
    
    func writeArray(dict: [RemDict]) {
        if let currentCategory = createdTask {
            
            if (addedTasks?[0]) != nil {
                
                try! realm.write {
                    realm.delete(currentCategory.remBD)
                    
                }
            }
            print(currentCategory.remBD)
            for di in dict {
                
                let container = try! Container()
                try! container.write { transaction in
                    
                    if (addedTasks?[0]) != nil {
                        
                        transaction.append1(items: currentCategory.remBD, number: di.number, day: di.day, isSelected: di.isSelected)
                        
                    } else {
                        transaction.append1(items: currentCategory.remBD, number: di.number, day: di.day, isSelected: di.isSelected)
                    }
                }
            }
        }
    }
    
    func save(tasks: AddedTasks) {
        
        do {
            
            try realm.write{
                
                realm.add(tasks)
            }
        } catch {
            print("Error saving message \(error) ")
        }
        
        
        self.tableView.reloadData()
    }
    
    func loadTasks() {
        
        //        let newTask = AddedTasks()
        //        save(tasks: newTask)
        //        addedTasks = createdTask?.tasks.sorted(byKeyPath: "name", ascending: true)
        print("current \(String(describing: addedTasks))")
        //        self.tableView.reloadData()
        
    }
    
    func loadName() {
        addedTasks = createdTask?.tasks.sorted(byKeyPath: "name", ascending: true)
        for goal in addedTasks! {
            goals = goal.goals
            daysToRead = goal.readDays
            reminderTime = goal.reminderTime
        }
    }
}

//MARK: - Extension
extension AddTask: ChildViewControllerDelegate, RemindBDProtocol, ReminderTimeProtocol, GoalProtocol,  UITextFieldDelegate, getDict, tableViewReload {
    
    func reload() {
        self.tableView.reloadData()
        
        print("Protocol with reload teblView is worked")
    }
    
    func getArray(dict: [RemDict]) {
        
       arrayFromRemBD = dict
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("changed")
        return true
    }
  
    @objc func textFieldDidChange() {
        tableView.reloadData()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let text = selectedCellIdentifier
        
        if cellTips().cellArray.contains(text) {
            textField.text = text
            
        } else if loadedData {
            
            textField.text = addedTasks?[0].name
            loadedData = false
            
        } else {
            textField.text = textField.text
            
        }
        homeTaskName = textField.text!
        selectedCellIdentifier = ""
        print("Hi textFieldDidEndEditing delegate")
        print("\(selectedCellIdentifier) & \(homeTaskName) & \(textField.text!)")
        
                textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
                print(homeTaskName)
        
                if textField.isEditing {
                            tableView.reloadData()
                        }
    }
    
    func textTips(string: String) {
        tableView.reloadData()
        selectedCellIdentifier = string
        
    }
    
    func textRemindBD(text: [String]) {
        
        remindBDArray = []
        let week = DateFormatter().weekdaySymbols!
        //        remindBDArray.sort { week.firstIndex(of: $0)! < week.firstIndex(of: $1)! }
        guard Set(remindBDArray).isSubset(of: week) else {
            fatalError("The elements of the array must all be day names with the first letter capitalized")
        }
        let text1 = text.joined(separator: " ")
        
        remindBDArray.append(text1)
        daysToRead = text1
        
        if text1 == "" {
            remindBDArray = ["No"]
            daysToRead = "No"
        }
        
    }
    
    func textRemindTi(text: String) {
    
        if text == "" {
            reminderTime = "No"
        } else {
            reminderTime = text
        }
    }
    
    func getGoal(text: String) {
        goals = text
    }
    
    func setupHideKeyboardOnTap() {
        self.view.addGestureRecognizer(self.endEditingRecognizer())
        self.navigationController?.navigationBar.addGestureRecognizer(self.endEditingRecognizer())
    }
    
    private func endEditingRecognizer() -> UIGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:)))
        tap.cancelsTouchesInView = false
        return tap
    }
    
}
