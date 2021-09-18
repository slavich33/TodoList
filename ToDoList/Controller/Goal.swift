//
//  Goal.swift
//  ToDoList
//
//  Created by Slava on 04.08.2021.
//

import Foundation
import UIKit

class Goals: UIViewController {
    
    
    let oneYear = [1...365]
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
}

extension Goals: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        oneYear.count
    }
    
}
