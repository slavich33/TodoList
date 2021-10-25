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

class AddTask: UITableViewController, tableViewReload, getDict {
    
    
    func getArray(dict: [RemDict]) {
        
       arrayFromRemBD = dict
        
    }
    
    func writeArray(dict: [RemDict]) {
        if let currentCategory = createdTask {
            
            for di in dict {
                
                let container = try! Container()
                try! container.write { transaction in

                    transaction.append1(items: currentCategory.remBD, number: di.number, day: di.day, isSelected: di.isSelected)
                    
                }
            }
        }
    }
    
    func reload() {
        self.tableView.reloadData()
        
        print("Protocol with reload teblView is worked")
    }
    
    
    @IBAction func taskingTextField(_ sender: UITextField) {
        //        tableView.reloadData()
        //        UITextField().text = homeTaskName
        print("Tasking reload data working")
    }
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
    var goesToChilds = true
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
        //                        loadTasks()
        //        tableView.reloadData()
        tasking().textField?.delegate = self
        self.tableView.rowHeight = 44
        print("current Added tasks \(String(describing: addedTasks))")
        print("yey \(goals)")
        print("\(daysToRead)")
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        
        //       print("ViewWIll Dissapear")
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        
        if isMovingToParent {
            print("View did Dissapear")
        }
        if ((presentationController?.delegate?.presentationControllerDidDismiss) != nil) {
            print("View did Dissapear")
        }
        
        //        if goesToChilds == false {
//        validateList()
        //        }
        
    }
    
    
    
    
    
    //MARK: - TableVIew Data source Methods
    
    
    func validateList() {
        
        if let curRemList = createdTask {
            
            copiedRList = curRemList.remBD
            
            if let currentTask = addedTasks?[0] {
                if curRemList.remBD.isEqual(copiedRList)  {
                    print("They are equal")
                    
                } else {
                    try! realm.write {
                        realm.delete(curRemList.remBD)
                        createdTask?.remBD = copiedRList
                        realm.delete(copiedRList)
                        print("deleting current rembd")
                    }
                }
            }
        }
    }
    
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
            
            if remindBDArray[0] == "No" {
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        validateList()
        
        if segue.identifier == segues.goToTips {
            
            let destinationVC = segue.destination as! TaskTips
            
            destinationVC.reloadDelegate = self
            destinationVC.delegate = self
            
            if selectedCellIdentifier != "" {
                destinationVC.selectedCellValue = selectedCellIdentifier
                tableView.reloadData()
            }
            
            
        } else if segue.identifier == segues.goToRemindByDay {
            
            var destinationVC = segue.destination as! RemindBD
            
            destinationVC.delegate = self
            
            if let currentCategory = createdTask {
                
                destinationVC.createdRemBD = currentCategory
                //                destinationVC.calledOnce()
                if let currentData = addedTasks?[0] {
                    if currentData.goals != ""  {
                        
                        //try to change load rows inside AddedTask
                        //                        this is error with loading rows
                        
                        
                        //                        destinationVC.delegateRow = goals
                        
                        if destinationVC.createdRemBD?.remBD.first != nil {
                            destinationVC.loadDay()
                            //                            if let indexPath = tableView.indexPathForSelectedRow {
                            //                                for cr in currentCategory.remBD {
                            //                                    let dici = RemDict(number: cr.number, day: cr.day, isSelected: cr.isSelected)
                            //                                    destinationVC.dict = [dici]
                            ////                                    destinationVC.dict[indexPath.row].number = cr.uniqueKey
                            ////                                     destinationVC.dict[indexPath.row].isSelected = cr.done
                            ////                                     destinationVC.dict[indexPath.row].day = cr.name
                            //                                }
                            //                            destinationVC.loadDay()
                            
                            
                            
                            //                                for cr in currentCategory.remBD {
                            //                                    do {
                            //                                    try realm.write {
                            //                                        rem.done = cr.done
                            //                                    }
                            //                                    } catch {
                            //                                        print(error)
                            //                                    }
                            //                                }
                            
                        }
                        //                            destinationVC.loadDay()
                        //                            destinationVC.saveDay()
                        //                            destinationVC.cells?.first?.done = ((currentCategory.remBD.first?.done) != nil)
                        print("destination didn't nill")
                        
                        
                        print("try to load goals ti")
                    }
                } else {
                    
                    if destinationVC.createdRemBD?.remBD.first != nil {
                        //                        destinationVC.calledOnce()
                        //                        destinationVC.loadDay()
                        destinationVC.loadItems()
                        //                        print("destination didn't nill")
                    } else {
                        //                        destinationVC.calledOnce()
                        //                        destinationVC.saveDay()
                        //                        destinationVC.loadDay()
                        //                        destinationVC.loadItems()
                        //
                        print("just go to create rows")
                    }
                    //
                    //                        destinationVC.loadRows()
                    //                    destinationVC.createdRow = currentCategory
                    
                    //                        let homeRow = HomeTasks()
                    //                        try! realm.write {
                    //                            realm.add(homeRow)
                    //                        }
                    //                        destinationVC.createdRow = homeRow
                }
            }
            
            
        } else if segue.identifier == segues.goToReminderTime {
            
            let destinationVC = segue.destination as! RemindTi
            
            destinationVC.delegate = self
        } else if segue.identifier == segues.goToGoal {
            
            let destinationVC = segue.destination as! Goals
            
            destinationVC.delegate = self
            
            if let currentCategory = createdTask {
                
                destinationVC.createdRow = currentCategory
                
                if let currentData = addedTasks?[0] {
                    if currentData.goals != ""  {
                        
                        //try to change load rows inside AddedTask
                        //                        this is error with loading rows
                        
                        
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
                    //                        destinationVC.loadRows()
                    //                    destinationVC.createdRow = currentCategory
                    print("just go to create rows")
                    //                        let homeRow = HomeTasks()
                    //                        try! realm.write {
                    //                            realm.add(homeRow)
                    //                        }
                    //                        destinationVC.createdRow = homeRow
                }
            }
        }
    }
    //MARK: - Add New Tasks
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        
        //        print(addedTasks?[0] as Any)
        
        
        if let currentCategory = createdTask {
            print("\(currentCategory)")
            print("\(homeTaskName) goes to create current category")
            if let currentData = addedTasks?[0] {
                if currentData.name != "" {
                    do {
                        try self.realm.write {
                            //                            let newTask = AddedTasks()
                            //                            newTask.name = homeTaskName
                            //                            print(homeTaskName)
                            //                            currentCategory.tasks.append(newTask)
                            currentCategory.name = homeTaskName
                            currentCategory.arrayDays = daysToRead
                            currentData.name = homeTaskName
                            //                            if let currentGoal =
                            currentData.goals = goals
                            currentData.readDays = daysToRead
                            
                            //                            if currentData.remBD == currentCategory.remBD {
                            //                                realm.delete(currentData.remBD)
                            //                                let newTask = AddedTasks()
                            //                                var newRemBD = List<RemBD>()
                            //                                newRemBD = currentCategory.remBD.detached()
                            //                                newTask.remBD = newRemBD
                            //                            currentData.remBD.append(objectsIn: newRemBD)
                            //                            } else {
                            //
                            //                            }
                            
                            //                            let newTask = AddedTasks()
                            //                            var newRemBD = List<RemBD>()
                            //                            newRemBD = currentCategory.remBD.detached()
                            //                            newTask.remBD = newRemBD
                            //                            let newRemBD = currentCategory.remBD
                            //                            var d = [RemDict(managedObject: RemBD())]
                            
                            //                            for rbd in newRemBD {
                            //                                equalRemBD.number = rbd.number
                            //                                equalRemBD.day = rbd.day
                            //                                equalRemBD.isSelected = rbd.isSelected
                            //                                d.append(equalRemBD)
                            ////                                print(equalRemBD)
                            ////                                print(d)
                            ////                                equalRemBD.
                            //                            }
                            
                            //                            self.equatDelegate.getArr(dict: d)
                            
                            
                        }
                    } catch  {
                        print("Error saving message \(error) ")
                    }
                }
                // Try to make code here
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
                            let newGoal = GoalsTI()
                            newGoal.rowNumber = Int(goals) ?? 0
                            
                            
                            
                            //                            var copiedRBD = [RemBD]()
                            //                            for r in currentCategory.remBD {
                            //                                let unmanagedRBD = RemBD(value: r)
                            //                                copiedRBD.append(unmanagedRBD)
                            //                            }
                            
                           
                            //                            var newRemBD = List<RemBD>()
                            //                            newRemBD = currentCategory.remBD
                            //                            newTask.remBD.append(objectsIn: newRemBD)
                            
                            //                            var d = [RemDict(managedObject: RemBD())]
                            //                            for rbd in newRemBD {
                            //                                equalRemBD.number = rbd.number
                            //                                equalRemBD.day = rbd.day
                            //                                equalRemBD.isSelected = rbd.isSelected
                            //                                d.append(equalRemBD)
                            ////                                print(equalRemBD)
                            ////                                print(d)
                            ////                                equalRemBD.
                            //                            }
                            //
                            self.equatDelegate.getArr(dict: copiedRList)
                            
                            //                            print(homeTaskName)
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
                            
                            currentCategory.name = homeTaskName
                            currentCategory.arrayDays = daysToRead
                        }
                    } catch  {
                        print("Error saving message \(error) ")
                    }
                    
                }
                
            }
            
            
            //            if currentCategory.remBD != copiedRList {
            //                try! realm.write {
            //                    currentCategory.remBD = copiedRList
            //                    print("deleting current rembd")
            //                }
            //            } else {
            //                    print("They are equal")
            //                }
            
            validateList()
            
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
        
        
        //        }
    }
    //MARK: - data manipulation methods
    
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
        }
    }
}

//MARK: - Extension
extension AddTask: ChildViewControllerDelegate, RemindBDProtocol, ReminderTimeProtocol, GoalProtocol,  UITextFieldDelegate {
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("changed")
        return true
    }
    //
    //    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    //        if textField.text != "" {
    //
    //            return true
    //        } else {
    //            textField.placeholder = "Type something"
    //
    //            return false
    //
    //        }
    //
    //    }
    //    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    //
    //        textField.endEditing(true)
    //        return true
    //    }
    
    //    func textFieldDidBeginEditing(_ textField: UITextField) {
    //        reloadTable()
    //    }
    //    let editingChanged = UIAction { _ in
    //        // Do something when text changes...
    //    }
    //    myTextField.addAction(editingChanged, for: .editingChanged)
    @objc func textFieldDidChange() {
        tableView.reloadData()
    }
    
    //    func textChanged () {
    //        if let currentData = addedTasks?[0] {
    //            if currentData.name != "" {
    //                AddTask.loadedData = true
    //                print("AddTask.loadedData chaned to true")
    //                print(AddTask.loadedData)
    //            } else {
    //                AddTask.loadedData = false
    //                print("AddTask.loadedData chaned to false")
    //                print(AddTask.loadedData)
    //            }
    //        }
    //    }
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
        
        //        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        //        print(homeTaskName)
        
        //        if textField.isEditing {
        //                    tableView.reloadData()
        //                }
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
        
        reminderTime = text
        
        if text == "" {
            reminderTime = "No"
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
