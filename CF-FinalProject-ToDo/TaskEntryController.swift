//
//  TaskEntryController.swift
//  CF-FinalProject-ToDo
//
//  Created by Chris Hahn on 10/13/17.
//  Copyright © 2017 Sturnella. All rights reserved.
//

import UIKit
import CoreData
import Foundation

protocol TaskEntryControllerDelegate: class {
    func didAddNewTask()
}

class TaskEntryController: UIViewController, UITableViewDelegate, UIPopoverPresentationControllerDelegate {

    var delegate: TaskEntryControllerDelegate?

    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        //return .fullScreen
        return .none
    }
    
    @IBOutlet weak var taskDescInputField: UITextField!
    
    var list: List?
    var tasks = [Task]()
    
    var taskDescValue = ""

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let tasks = list?.childTasks {
            self.tasks = tasks.allObjects as! [Task]
        }
    }
    
    @IBAction func saveData(_ sender: Any) {
   
        if let taskDescValue = taskDescInputField.text, !taskDescValue.isEmpty {
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Task", in: context)
            
            //let task = NSManagedObject(entity: entity!, insertInto: context)
            let task = Task(entity: entity!, insertInto: context)
            
            task.setValue(taskDescValue, forKey: "taskDesc")
            task.taskDesc = taskDescValue
            task.parentList = list
            
            appDelegate.saveContext()
            tasks.append(task)
            
            if let delegate = delegate {
                delegate.didAddNewTask()
            }
            
            print(" ... printing tasks from TaskEntryController after appends ... ")
            print(tasks)
            
            ClearText()
            
        } else {
            
            showTextMessage()
            
        }
    
    }
    
    func showTextMessage() {
        let alertController = UIAlertController(title: "Data required", message: "All fields require data entry before saving is permitted", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Close", style: .cancel)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
        
    }
    
    func ClearText() {
        //listTitleInputField.text = ""
        taskDescInputField.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /*
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
         if let tasks = list?.tasks {
             self.tasks = tasks.allObjects as! [Task]
         }
     }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            lists = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Fetching Error: \(error.userInfo)")
        }
    }
    */
}
