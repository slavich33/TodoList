//
//  File.swift
//  ToDoList
//
//  Created by Slava on 02.08.2021.
//

import Foundation
import UIKit
import RealmSwift

protocol ReminderTimeProtocol {
    func textRemindTi(text: String)
}

class RemindTi: UIViewController {
    
    let realm = try! Realm()
    var uploadedDate: Results<ReminderTI>?
    var currentDate = "No"
    let formatter = DateFormatter()
    
    
    @IBOutlet var datePicker: UIDatePicker!
    
    public var delegate: ReminderTimeProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadDate()
    }
    
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        
        doneButton()
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func doneButton() {
        
        
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        
        
        
        currentDate = formatter.string(from: datePicker.date)
        print(currentDate)
        
        self.delegate.textRemindTi(text: currentDate)
        
        let newTime = ReminderTI()
        try! realm.write{
            newTime.date = currentDate
            realm.add(newTime, update: .all)
        }
    }
    
    func loadDate() {
        
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        
        
        uploadedDate = realm.objects(ReminderTI.self)
        
        if let date = uploadedDate {
            
            for pickedDate in date {
                
                datePicker.setDate(formatter.date(from: pickedDate.date)!, animated: true)
                
            }
        }
    }
}


