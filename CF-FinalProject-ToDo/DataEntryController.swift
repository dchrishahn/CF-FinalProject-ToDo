//
//  DataEntryController.swift
//  CF-FinalProject-ToDo
//
//  Created by Chris Hahn on 9/18/17.
//  Copyright © 2017 Sturnella. All rights reserved.
//

import UIKit
import CoreData
import Foundation

protocol DataEntryControllerDelegate: class {
    func didAddNewData()
}

class DataEntryController: UIViewController, UITableViewDelegate, UIPopoverPresentationControllerDelegate {

    var delegate: DataEntryControllerDelegate?
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        //return .fullScreen
        return .none
    }
    
    @IBOutlet weak var listTitleInputField: UITextField!
    @IBOutlet weak var taskDescInputField: UITextField!
    
    var lists = [NSManagedObject]()
    //var tasks = [NSManagedObject]()
    
    var listTitleValue = ""
    //var taskDescValue = ""
    
    @IBAction func saveData(_ sender: Any) {
    
        if let listTitleValue = listTitleInputField.text, !listTitleValue.isEmpty {
            //let taskDescValue = taskDescInputField.text, !taskDescValue.isEmpty {
         
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let entityList = NSEntityDescription.entity(forEntityName: "List", in: context)
            //let entityTask = NSEntityDescription.entity(forEntityName: "Task", in: context)
            
            let list = NSManagedObject(entity: entityList!, insertInto: context)
            //let task = NSManagedObject(entity: entityTask!, insertInto: context)
            
            list.setValue(listTitleValue, forKey: "listTitle")
            //task.setValue(taskDescValue, forKey: "taskDesc")
            
            appDelegate.saveContext()
            lists.append(list)
            //tasks.append(task)
            
            if let delegate = delegate {
                delegate.didAddNewData()
            }
            
            print(" ... printing lists and tasks from DataEntryController after appends ... ")
            print(lists)
            //print(tasks)
            
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
        listTitleInputField.text = ""
        //taskDescInputField.text = ""
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "List")
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            lists = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Fetching Error: \(error.userInfo)")
        }
    }


}
