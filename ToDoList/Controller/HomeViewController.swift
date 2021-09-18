//
//  HomeView.swift
//  ToDoList
//
//  Created by Slava on 06.06.2021.
//

import UIKit
import RealmSwift


let dateReuseIdentifier = "dayCell"
let startingIndex = 400



class HomeViewController:  UIViewController, UITableViewDelegate, UITableViewDataSource, tableViewReload, UIAdaptivePresentationControllerDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    let realm = try! Realm()
    var tappedOnTheCell = false
    var homeArray: Results<HomeTasks>?
    
    
    
    @IBOutlet weak var selectedDate: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func GoToToday(_ sender: Any) {
        scrollToDate(date: Date())
    }
    
  
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationItem.hidesBackButton = true
      
        loadTasks()
        tableView.reloadData()
        print("View appeared")
//        reload()
        print(tappedOnTheCell)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        loadTasks()
//        navigationItem.hidesBackButton = true
        displayDate(date: Date())
//        tableView.reloadData()
       
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        scrollToDate(date: Date())
        
    }
    
    
    //MARK: - TableView DataSource Methods
    func reload() {
       
            print("Reloaded")
        self.tableView.reloadData()
        for home in homeArray! {
            if home.name == "" {
                try! realm.write {
                    realm.delete(home)
                    self.tableView.reloadData()
                    print("Deleted")
                }
            }
        }
        
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeArray?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell") as! homeCell
        
//        let homeName = HomeTasks().tasks
//        for name in homeName {
//            cell.homeLabel.text = name.name
//        
//        }
        
        
//        let task =
        cell.textLabel?.text = homeArray?[indexPath.row].name
//        cell.homeLabel.text = homeArray?[indexPath.row].name ?? "No Tasks added"
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
//        let destination = ViewController.self as! AddTask
//
//        if let indexPath = tableView.indexPathForSelectedRow {
//            destination.selectedCategory = categoryArray?[indexPath.row]
//        }
     
        if homeArray?[indexPath.row].name != "" {
          
            performSegue(withIdentifier: "createTask", sender: self)
            tappedOnTheCell = true
            print("Selected cell in did row now is \(tappedOnTheCell)")
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
  //MARK: - Add New Tasks
    
    @IBAction func addButton(_ sender: UIButton) {
        
        
       
        let newTask = HomeTasks()
        self.save(tasks: newTask)
        
        performSegue(withIdentifier: "createTask", sender: self)
   
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "createTask" {
            
            let nav = segue.destination as! UINavigationController
            let destination = nav.topViewController as! AddTask
            destination.delegate = self
            segue.destination.presentationController?.delegate = self
//            let destin = nav.topViewController as! Goals
//          if let task = homeArray {
//            for name in task {
//                if name.name == ""{
//                try! realm.write{
//                    if let indexPath = tableView.indexPathForSelectedRow {
//                        destination.createdTask = name
//                    }
//                  }
//            }
//            }
//            }
            
//            if tappedOnTheCell == false {
                    for task in homeArray!{
                        if let indexPath = tableView.indexPathForSelectedRow {
//                                                        try! realm.write{
//                                destination.createdTask?.name = task.name}
                        destination.createdTask = homeArray?[indexPath.row]
                            destination.loadName()
//                            destination.goals = destination.addedTasks.
//                            destination.goals = task.
                            print("Perform segue with selected row, and load i guess")
                           

                        //try to make it work



                        }
//                            if let indexPath = tableView.indexPathForSelectedRow {
                                if task.name == "" {
                                    destination.createdTask = task
//                                    destin.createdRow = task
                                    print("Perform segue and create goal in Goals")
                   
                
//                            }
          
//
                        }
                 }
                }
             
//                        if homeArray?.name != "" {
//                            destination.createdTask = homeArray?[indexPath.row]
//                            print("Perform segue with selected row, and load i guess")
//                            print( "selected cell in add button now is \(tappedOnTheCell)")
//                        }
            
            }
        
        
    

    public func presentationControllerDidDismiss(
       _ presentationController: UIPresentationController)
     {
       // Only called when the sheet is dismissed by DRAGGING.
       // You'll need something extra if you call .dismiss() on the child.
       // (I found that overriding dismiss in the child and calling
       // presentationController.delegate?.presentationControllerDidDismiss
       // works well).
        reload()
        print("Child was dismissed")
     }
   
    

//MARK: - Data Manipulation Methods

func loadTasks() {
    
    homeArray = realm.objects(HomeTasks.self)
           
    self.tableView.reloadData()
}
    
    func save(tasks: HomeTasks) {
        
        do {
            
            try realm.write{
                
                realm.add(tasks)
            }
        } catch {
            print("Error saving message \(error) ")
        }
        
        
        self.tableView.reloadData()
    }

}
    
    
    //MARK: - CollectionViews Calendar code
    extension HomeViewController:  UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        
    
    func selectCell(cell: DateCollectionViewCell) {
        if let selectedCellDate = cell.date {
            displayDate(date: selectedCellDate)
        }
    }
    
    func displayDate(date: Date) {
        UsedDates.shared.displayedDate = date
        UsedDates.shared.selectdDayOfWeek = Calendar.current.component(.weekday, from: date) //so that if the selected date is Wednesday, it keeps selecting Wednesday next week
        self.selectedDate.text = UsedDates.shared.displayedDateString
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9999
    }
    
    func scrollToDate(date: Date)
    {
        print("will scroll to today")
        let startDate = UsedDates.shared.startDate
        let cal = Calendar.current
        if let numberOfDays = cal.dateComponents([.day], from: startDate, to: date).day {
            let extraDays: Int = numberOfDays % 7 // will = 0 for Mondays, 1 for Tuesday, etc ..
            let scrolledNumberOfDays = numberOfDays - extraDays
            let firstMondayIndexPath = IndexPath(row: scrolledNumberOfDays, section: 0)
            collectionView.scrollToItem(at: firstMondayIndexPath, at: .left , animated: false)
        }
        displayDate(date: date)
    }

        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        displayWeek()
    }
    
    func displayWeek() {
        var visibleCells = collectionView.visibleCells
        visibleCells.sort { (cell1: UICollectionViewCell, cell2: UICollectionViewCell) -> Bool in
            guard let cell1 = cell1 as? DateCollectionViewCell else {
                return false
            }
            guard let cell2 = cell2 as? DateCollectionViewCell else {
                return false
            }
            let result = cell1.date!.compare(cell2.date!)
            return result == ComparisonResult.orderedAscending
            
        }
        let middleIndex = visibleCells.count / 2
        let middleCell = visibleCells[middleIndex] as! DateCollectionViewCell
        
        let displayedDate = UsedDates.shared.getDateOfAnotherDayOfTheSameWeek(selectedDate: middleCell.date!, requiredDayOfWeek: UsedDates.shared.selectdDayOfWeek)
        displayDate(date: displayedDate)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let addedDays = indexPath.row
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: dateReuseIdentifier, for: indexPath) as! DateCollectionViewCell

        var addedDaysDateComp = DateComponents()
        addedDaysDateComp.day = addedDays//calculating the date of the given cell
        let currentCellDate = Calendar.current.date(byAdding: addedDaysDateComp , to: UsedDates.shared.startDate)
        
        if let cellDate = currentCellDate {
            cell.date = cellDate
            let dayOfMonth = Calendar.current.component(.day, from: cellDate)
            cell.DayOfTheMonth.text = String(describing: dayOfMonth)
            
            let dayOfWeek = Calendar.current.component(.weekday, from: cellDate)
            cell.DayOfTheWeek.text = String(describing: UsedDates.shared.getDayOfWeekLetterFromDayOfWeekNumber(dayOfWeekNumber: dayOfWeek))
            
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? DateCollectionViewCell {
            UsedDates.shared.displayedDate = cell.date!
            UsedDates.shared.selectdDayOfWeek = Calendar.current.component(.weekday, from: cell.date!)
            selectedDate.text = UsedDates.shared.displayedDateString
            print("Selected Date: \(UsedDates.shared.displayedDateString)")
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: collectionView.bounds.width/7, height: collectionView.bounds.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 0
    }
}
