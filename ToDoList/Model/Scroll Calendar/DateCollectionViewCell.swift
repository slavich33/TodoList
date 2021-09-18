//
//  DateCollectionViewCell.swift
//  ToDoList
//
//  Created by Slava on 07.06.2021.
//

import UIKit

class DateCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var DayOfTheWeek: UILabel!
    @IBOutlet weak var DayOfTheMonth: UILabel!
    
    var date: Date?
}
