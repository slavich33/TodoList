//
//  AddTask.swift
//  ToDoList
//
//  Created by Slava on 04.07.2021.
//

import Foundation
import UIKit
import RealmSwift

protocol tableViewReload {
    func reload()
}

class AddTask: UITableViewController, tableViewReload {
    func reload() {
        self.tableView.reloadData()
        
        print("Protocol with reload teblView is worked")
    }
    
    
    @IBAction func taskingTextField(_ sender: UITextField) {
//        tableView.reloadData()
//        UITextField().text = homeTaskName
        print("Tasking reload data working")
    }
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
//        print("current createdTasks \(String(describing: createdTask))")
           print("yey \(goals)")
    }
//    override func viewWillDisappear(_ animated: Bool) {
//        if homeTaskName != "" {
//
//            self.delegate.reload()
//            print("Holla")
//        }
//    }
    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(true)
//        print("View Dissapeared")
//        print("Current textField name is: \(homeTaskName) & \(tasking().textField?.text )")

//        if ((navigationController?.popToRootViewController(animated: true)) != nil) {
//            if homeTaskName != "" {
//
//                self.delegate.reload()
//                print("Goes to parent root controller")
//            }
//        }

//            if homeTaskName != "" {
//
//                self.delegate.reload()
//                print("Holla")
//            }
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
            
//            if let task = addedTasks?[indexPath.row] {
//                cell.textField.text = task.name
//            }
//            else {
            
            
//            textFieldDidBeginEditing(cell.textField)
            
            textFieldDidEndEditing(cell.textField)
            cell.textField.delegate = self
//            }
//            if let currentTask = addedTasks?[0] {
//                cell.textField.text = currentTask.name
//                textFieldDidEndEditing(cell.textField)
//                cell.textField.delegate = self
//            }
//            cell.delegate = self
//            cell.textField.text = homeTaskName
            

            //            task.name = (cell.textLabel?.text) ?? "def"
            //            save(tasks: task)
            //            homeTaskName = cell.textField.text!
            
            return cell
            
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "remindByDay") as! remindByDay
            
            let rmbdString = remindBDArray.joined(separator: " ")
            
            cell.timeLabel?.text = rmbdString
            
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
            
            
        } else if segue.identifier == segues.goToReminderTime {
            
            let destinationVC = segue.destination as! RemindTi
            
            destinationVC.delegate = self
        } else if segue.identifier == segues.goToGoal {
            
            let destinationVC = segue.destination as! Goals
            
            destinationVC.delegate = self
//            destinationVC.reloadDelegate = self
            
            if let currentCategory = createdTask {
            
                if let currentData = addedTasks?[0] {
                    if currentData.goals != ""  {
                        
                       //try to change load rows inside AddedTask
                       
                        destinationVC.createdRow = currentCategory
//                        destinationVC.loadedData1 = true
//                        destinationVC.delegateRow = currentData.goals
                        destinationVC.delegateRow = goals
                        destinationVC.changedRow = goals
                        destinationVC.loadRows()
                        
//                        destinationVC.showSelectedRow()
//                        destin
                    print("try to load goals ti")
                    }
                    } else {
                        destinationVC.createdRow = currentCategory
                        if destinationVC.createdRow?.goals.first != nil {
                            destinationVC.loadRows()
                            print("destination didn't nill")
                        }
//                        destinationVC.loadRows()
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
            
            
//            for goal in addedTasks! {
//            if let indexPath = tableView.indexPathForSelectedRow {
////                                                        try! realm.write{
////                                destination.createdTask?.name = task.name}
//
//
////                destinationVC.createdGoal = addedTasks?[indexPath.row]
//                destinationVC.loadRows()
////                destinationVC.createdGoal?.goals = (addedTasks?[indexPath.row].goals)!
////                destinationVC.loadRows()
//                print("Perform segue with selected row, and load i guess")
//            }
//                if goal.goals != ""{
//                    if goal.goals != "Unlimited" {
//                        destinationVC.createdGoal = goal
//                    }
//                }
//                
//        }
//            try to make it work



            
//            destinationVC.createdGoal = addedTasks
            
            
        
        
    
    
    //MARK: - Add New Tasks
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        
        print(addedTasks?[0] as Any)
        
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
                            currentData.name = homeTaskName
//                            if let currentGoal =
                            currentData.goals = goals
//                            currentCategory.name = currentData.name
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
//                                let newGoal = GoalsTI()
                                newTask.name = homeTaskName
                                newTask.goals = goals
//                                newGoal.rowNumber = Int(goals) ?? 0
                                print(homeTaskName)
                                currentCategory.tasks.append(newTask)
//                                currentCategory.goals.append(newGoal)
                                currentCategory.name = homeTaskName
                                
                            }
                        } catch  {
                            print("Error saving message \(error) ")
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
        
        if text1 == "" {
            remindBDArray = ["No"]
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
