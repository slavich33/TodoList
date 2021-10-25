//
//  TaskTips.swift
//  ToDoList
//
//  Created by Slava on 11.07.2021.
//

import Foundation
import UIKit
import RealmSwift

protocol ChildViewControllerDelegate {
    
    func textTips(string: String)
    
    
}

class TaskTips: UITableViewController{
    
    
    public var delegate: ChildViewControllerDelegate!
    public var reloadDelegate: tableViewReload!
    
    var cells = [Tips]()
    
    var selectedCellValue = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cells.append(Tips.init(sectionName: "Health", cellName: ["Working out", "Drink water", "Jogging", "Call doctor"]))
        cells.append(Tips.init(sectionName: "Family Time", cellName: ["Go out with kids", "Gymnastics with child", "Pool with family", "Call to parents"]))
        cells.append(Tips.init(sectionName: "Self Development", cellName: ["Learning new language", "Reading", "Meditation", "Go to gym"]))
        cells.append(Tips.init(sectionName: "House Work", cellName: ["Cleaning", "Go to market", "Cook a dinner", "Dissemble a closet"]))
        
        tableView.reloadData()
    }
    //MARK: - TableView Methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return cells.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells[section].cellName?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell.textLabel?.text = cells[indexPath.section].cellName?[indexPath.row]
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if let indexPath = tableView.indexPathForSelectedRow {

            if let name = cells[indexPath.section].cellName?[indexPath.row] {
                
                self.delegate.textTips(string: name)
                
                self.reloadDelegate.reload()

            }
               
            tableView.reloadData()
            self.navigationController?.popViewController(animated: true)
            
        }
    }
    
//MARK: - TableView Front Methods
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        
        view.backgroundColor = .systemGray.withAlphaComponent(0.5)
        
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: view.frame.width, height: 40))
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = cells[section].sectionName
        view.addSubview(label)
        
        return view
        
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
}
    



//MARK: - Examples of code

//let realm = try! Realm()
//var taskTips: Results<TipsTasks>?
//
//var selectedTips: AddedTasks? {
//    didSet {
//        loadItems()
//    }
//}

//    func save(category: TipsTasks){
//
//        do {
//
//            try realm.write{
//                realm.add(category)
//            }
//        } catch {
//            print("Error saving message \(error) ")
//        }
//
//
//        self.tableView.reloadData()
//    }
//    func loadItems() {
//
//        taskTips = realm.objects(TipsTasks.self)
//
//    }
//
//}


//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return cells[section].sectionName
//    }

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        if segue.identifier == "tipsCollected" {
//
//            let destinationVC = segue.destination as! AddTask
//
//            if let indexPath = tableView.indexPathForSelectedRow {
//                destinationVC.tipsVa.tipsVal = cells[indexPath.section].cellName?[indexPath.row]
//
//                tableView.reloadData()
//            }
//        }
//
//    }

//        self.navigationController?.pushViewController(add, animated: true)
//        dismiss(animated: true, completion: nil)

//        self.dismiss(animated: true, completion: nil)
//        navigationController?.navigationBar.backItem?.hidesBackButton = true
//        performSegue(withIdentifier: "tipsCollected", sender: self)


//        self.navigationController?.popToViewController(AddTask(), animated: true)

//    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
//        guard let vc = navigationController.topViewController as? AddTask else { return }
//                vc.selectedCellIdentifier = tipsValues ?? "0"
//    }

//        tableView.sectionHeaderHeight = 40
//        tableView.rowHeight = 40
//        tableView.tableFooterView?.isHidden = true
