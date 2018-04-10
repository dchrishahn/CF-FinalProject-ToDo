//
//  DetailViewController.swift
//  CF-FinalProject-ToDo
//
//  Created by Chris Hahn on 9/13/17.
//  Copyright © 2017 Sturnella. All rights reserved.
//
// *******  Controller for the purpose of viewing tasks.  Contains "newTaskButton" to present AlertController to add new tasks.     *******
// *******  newTaskButton calls the "createTask" function.  viewWillAppear handles some refreshing and assigning? lists to tasks?   *******
// *******  viewDidLoad has code to create an edit button on the right and a button for returning to the lists                      *******

import UIKit
import CoreData
import Foundation

//class DetailViewController: UITableViewController {
class DetailViewController: UITableViewController, NSFetchedResultsControllerDelegate, UIPopoverPresentationControllerDelegate {
    
    var list: List?
    var tasks = [Task]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.refreshControl?.addTarget(self, action: #selector(DetailViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        
        if let tasks = list?.childTasks {
            self.tasks = tasks.allObjects as! [Task]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl?.addTarget(self, action: #selector(DetailViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        navigationItem.leftItemsSupplementBackButton = true
        
        self.clearsSelectionOnViewWillAppear = false
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Add task descriptions ...
    @IBAction func newTaskButton(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Add Task", message: "", preferredStyle: .alert)
        
        alertController.addTextField(configurationHandler: {(_ textField: UITextField) -> Void in
            textField.placeholder = "enter task description"
        })
        
        let confirmAction = UIAlertAction(title: "Save", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            if let taskName = alertController.textFields?[0].text {
                self.createTask(title: taskName)
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    func createTask(title: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Task", in: context)
        
        let task = Task(entity: entity!, insertInto: context)
        task.taskDesc = title
        task.parentList = list
        appDelegate.saveContext()
        tasks.append(task)
        
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellTwo", for: indexPath)
        let task = tasks[indexPath.row]
        let taskname = task.taskDesc
        cell.textLabel?.text = taskname
        
        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            deleteObject(tasks[indexPath.row])
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    func deleteObject(_ object: NSManagedObject) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        managedContext.delete(object)
        appDelegate.saveContext()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if editing {
            tableView.setEditing(true, animated: true)
        } else {
            tableView.setEditing(false, animated: true)
        }
    }
    
    // Override to support rearranging the table view.  in previous versions was moveRowAtIndexPath
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        print("")
        print("detailVC moveRowAt function")
        print("")
        let taskObj = tasks[fromIndexPath.row]
        tasks.remove(at: fromIndexPath.row)
        tasks.insert(taskObj, at: to.row)
    }
    
    // Override to support conditional rearranging of the table view.  in previous versions was canMoveRowAtIndexPath
    override func tableView(_ tableview: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
}


/*
// ****************************************************************************************************************
    override func viewDidLoad() {
        super.viewDidLoad()
 
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableData), name: NSNotification.Name(rawValue: "TaskEntryViewControllerDidSaveData"), object: nil)
 
        print("breakpoint 1 - DetailVC")
    }
 
    func reloadTableData(_ notification: Notification) {
        loadDataFromCoreData()
        self.tableView.reloadData()
    }
 
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
 
    override func viewWillAppear(_ animated: Bool) {
 
        loadDataFromCoreData()
        
    }
 
    func loadDataFromCoreData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            tasks = results as! [Task]
            print("breakpoint 2 - DetailVC - loadDataFromCoreData")
            
        } catch let error as NSError {
            print("Fetching Error: \(error.userInfo)")
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        print("breakpoint 3 - DetailVC - table-numberOfSections")
        return 1
    }
 
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        }
 
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        //return .fullScreen
        return .none
    }
    
 
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}

extension DetailViewController: TaskEntryControllerDelegate {
    func didAddNewTask() {
        loadDataFromCoreData()
        self.tableView.reloadData()
    }    
}
// ****************************************************************************************************************
*/
