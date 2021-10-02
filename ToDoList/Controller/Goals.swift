//
//  Goal.swift
//  ToDoList
//
//  Created by Slava on 04.08.2021.
//

//import Foundation
//import UIKit
//import RealmSwift
//
//protocol GoalProtocol {
//
//    func getGoal(text: String)
//
//}
//
//protocol loadedData {
//    func getData(data: Bool)
//}
//
//class Goals: UIViewController {
//
//    @IBOutlet var daysPicker: UIPickerView!
//
//    var days: [String] = []
//
//    public var delegate: GoalProtocol!
//    public var loadedDelegate: loadedData!
//    let realm = try! Realm()
//    var selRow: Results<GoalsTI>?
//    var delegateRow = "Unlimited"
//    var pickerRow: Int = 0
//    var loadedData1: Bool = false
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        navigationController?.delegate = self
//
//        daysPicker.dataSource = self
//        daysPicker.delegate = self
//
//        daysDescription()
//        loadRows()
//        showSelectedRow()
//        print("\(selRow)")
//        print(delegateRow.startIndex.hashValue)
//
//
//    }
//
//
//
//    func daysDescription() {
//
//        days.append("Unlimited")
//
//        for eachDay in [1] {
//            days.append(eachDay.description + " day")
//        }
//
//        for day in 2...365 {
//            days.append(day.description + " days")
//        }
//
//
//
//    }
//
//    func showSelectedRow() {
//
//        guard let selectedRow = realm.objects(GoalsTI.self).first else {return}
//        let row = selectedRow.rowNumber
//
//        if loadedData1 {
//            daysPicker.selectRow(row, inComponent: 0, animated: true)
//        }
//        print(row)
//
//    }
//
//
//    @IBAction func doneButton(_ sender: UIBarButtonItem) {
//
//        addRow()
//        self.delegate.getGoal(text: delegateRow)
//        self.navigationController?.popViewController(animated: true)
//
//    }
//
//func loadRows() {
//
//    selRow = realm.objects(GoalsTI.self)
//
//    }
//}
//extension Goals: UIPickerViewDataSource, UIPickerViewDelegate, UINavigationControllerDelegate {
//
//        func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
//            (viewController as? AddTask)?.goals = delegateRow
//
////            addRow()
//
//    //                 realm.add(newRow)
//
//        }
//
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        days.count
//    }
//
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return days[row]
//    }
//
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        let selectedRow = days[row].description
//        print(selectedRow)
//        delegateRow = selectedRow
//        pickerRow = row
//
//
//        let newRow = GoalsTI()
//        try! realm.write{
//                newRow.rowNumber = pickerRow
//            newRow.rowDesc = delegateRow
////            realm.add(newRow)
//            }
//    }
//
//    func addRow() {
//
//        guard let crRow = selRow else { return}
//
////        for goal in crRow {
////            if goal.rowNumber ==  {
////
////            }
////        }
//        print(loadedData1)
//
//        if loadedData1 {
//            do {
//                try self.realm.write {
//                    print("write row")
//                    let newRow = GoalsTI()
//                    newRow.rowDesc = delegateRow
//                    newRow.rowNumber = pickerRow
//
//                }
//            } catch  {
//                print("Error saving message \(error) ")
//            }
//        } else {
//            try! realm.write{
//                let newRow = GoalsTI()
//                newRow.rowDesc = delegateRow
//                newRow.rowNumber = pickerRow
//                //                        currentCategory.goals.append(newRow)
//                realm.add(newRow, update: .all)
//            }
//        }
//    }
//
//}
        
              
//                if let currentData = selRow?[0] {
//                    if currentData.rowDesc != "" {
//                        do {
//                            try self.realm.write {
//
//
//                                currentData.rowDesc = delegateRow
//                                currentData.rowNumber = pickerRow
//                            }
//                        } catch  {
//                            print("Error saving message \(error) ")
//                        }
//                    }
//                }else {
//                if selRow == nil {
//                    try! realm.write{
//                        let newRow = GoalsTI()
//                        newRow.rowDesc = delegateRow
//                        newRow.rowNumber = pickerRow
////                        currentCategory.goals.append(newRow)
//                        realm.add(newRow)
//                    }
//                }
//
////
//            print(delegateRow)
//        }
//    }
//}


import Foundation
import UIKit
import RealmSwift

protocol GoalProtocol {
    
    func getGoal(text: String)
    
}

class Goals: UIViewController {
    
    @IBOutlet var daysPicker: UIPickerView!
    
    var days: [String] = []
    
    public var delegate: GoalProtocol!
    var pickerValueChanges = false
    
    let realm = try! Realm()
    var selRow: Results<GoalsTI>?
    var delegateRow = ""
    var pickerRow: Int = 0
    var changedRow = ""
    var createdRow: HomeTasks? {
        didSet {
            //            showSelectedRow()
            //            loadRows()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(createdRow as Any)
        navigationController?.delegate = self
        daysPicker.dataSource = self
        daysPicker.delegate = self
        
        daysDescription()
        //        loadRows()
        showSelectedRow()
        print("yey \(delegateRow)")
    }
    
    
    
    func daysDescription() {
        
        days.append("Unlimited")
        
        for eachDay in [1] {
            days.append(eachDay.description + " day")
        }
        
        for day in 2...365 {
            days.append(day.description + " days")
        }
        
    }
    
    func showSelectedRow() {
        
        guard let selectedRow = realm.objects(GoalsTI.self).first else {return}
        let row = selectedRow.rowNumber
        daysPicker.selectRow(pickerRow, inComponent: 0, animated: true)
        print(row)
        
    }
    
    
    @IBAction func doneButton(_ sender: UIBarButtonItem) {
        print("name of the current row will be \(delegateRow)")
        if pickerValueChanges {
            addRow()
        }
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func loadRows() {
        
        selRow = createdRow?.goals.sorted(byKeyPath: "rowDesc", ascending: true)
        for row in selRow! {
            //        daysPicker.selectRow(row.rowNumber, inComponent: 0, animated: true)
            pickerRow = row.rowNumber
            print(pickerRow)
            
        }
        //    selRow = realm.objects(GoalsTI.self)
        
    }
    
}
extension Goals: UIPickerViewDataSource, UIPickerViewDelegate, UINavigationControllerDelegate {
    
    //    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
    //        (viewController as? AddTask)?.goals = delegateRow
    //
    //
    ////                 realm.add(newRow)
    ////        addRow()
    //    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        days.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return days[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedRow = days[row].description
        print(selectedRow)
        delegateRow = selectedRow
        pickerRow = row
        pickerValueChanges = true
        //        self.delegate.getGoal(text: selectedRow)
        
        
        //        try! realm.write{
        //                newRow.rowNumber = row
        //            realm.add(newRow)
        //            if let currentCategory = createdRow {
        //                currentCategory.goals.append(newRow)
        //            }
        //            }
    }
    
    func addRow() {
        
        if let currentCategory = createdRow {
            if let currentData = selRow?[0] {
                if currentData.rowDesc != "" {
                    do {
                        try self.realm.write {
                            
                            print("rewrite current goal")
                            currentData.rowDesc = delegateRow
                            currentData.rowNumber = pickerRow
                           
//                            for task in currentCategory.tasks {
//                                task.goals = delegateRow
//                            }
                            
                        }
                    } catch  {
                        print("Error saving message \(error) ")
                    }
                }
            } else {
                if  changedRow == "" {
                    try! realm.write{
                        let newRow = GoalsTI()
                        newRow.rowDesc = delegateRow
                        newRow.rowNumber = pickerRow
                        currentCategory.goals.append(newRow)
                        realm.add(newRow)
                        print("create current goal and append to goals")
                    }
                }
            }
        }
        
        self.delegate.getGoal(text: delegateRow)
        
    }
    
}
