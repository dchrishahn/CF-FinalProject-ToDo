//
//  MasterViewController.swift
//  CF-FinalProject-ToDo
//
//  Created by Chris Hahn on 9/13/17.
//  Copyright © 2017 Sturnella. All rights reserved.
//

import UIKit
import CoreData
import Foundation


class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate, UIPopoverPresentationControllerDelegate {

    var lists = [List]()
    //var tasks = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl?.addTarget(self, action: #selector(MasterViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        //NotificationCenter.default.addObserver(self, selector: #selector(reloadTableData), name: .reload, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableData), name: NSNotification.Name(rawValue: "DataEntryViewControllerDidSaveData"), object: nil)
        
        //navigationItem.rightBarButtonItem = editButtonItem
        // Uncomment the following line to preserve selection between presentations
        //self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.navigationItem.leftBarButtonItem = self.editButtonItem
//        print("breakpoint 1 - MstrVC - viewDidLoad")
    }
    
    func reloadTableData(_ notification: Notification) {
        loadDataFromCoreData()
        self.tableView.reloadData()
    }
 
    
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    
    /*
    @nonobjc func controllerDidChangeContent(controller: NSFetchedResultsController<NSFetchRequestResult>) {
        // In the simplest, most efficient, case, reload the table view.
        tableView.reloadData()
    }
    */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.refreshControl?.addTarget(self, action: #selector(MasterViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        
        loadDataFromCoreData()
        
    }
    
    func loadDataFromCoreData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "List")
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            lists = results as! [List]
//            print("breakpoint 2 - MstrVC - viewWillAppear")
//            print("printing lists from MstrVC in the viewWillAppear function")
//            print(lists)
            
        } catch let error as NSError {
            print("Fetching Error: \(error.userInfo)")
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
//        print("breakpoint 3 - MstrVC - numOfSections")
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("breakpoint 4 - MstrVC - numOfRows")
        return lists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let list = lists[indexPath.row]
        let listTitle = list.value(forKey: "listTitle")
//        print("breakpoint 5 - MstrVC - cellForRowAt")
//        print("...next line is listTitle value")
//        print(listTitle as Any)
//        print(" ...")
        cell.textLabel?.text = "\(listTitle!)"
        //cell.textLabel?.text = states[indexPath.row].title
        return cell
        
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            deleteObject(lists[indexPath.row])
            lists.remove(at: indexPath.row)
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
    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
//        print("breakpoint 6 - MstrVC")
        let listObj = lists[fromIndexPath.row]
        lists.remove(at: fromIndexPath.row)
        lists.insert(listObj, at: to.row)
        
    }
    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    
    // MARK: - Add a new list
    @IBAction func newListButton(_ sender: UIBarButtonItem) {
    
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "DataEntryController") as! UINavigationController

        let dataEntryController = viewController.viewControllers.last as! DataEntryController
        dataEntryController.delegate = self
        
        viewController.modalPresentationStyle = .popover
        let popover: UIPopoverPresentationController = viewController.popoverPresentationController!
        
        popover.barButtonItem = sender
        popover.delegate = self
        
        present(viewController, animated: true, completion:nil)
//        print("breakpoint 7 - MstrVC - newListButton")
    }
    
    // MARK: - Segue to List creation or the DetailViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            //let viewController = segue.destination as! DetailViewController
            let viewController = (segue.destination as! UINavigationController).topViewController as! DetailViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow
            let list = lists[(selectedIndexPath?.row)!]
            viewController.list = list
        }
    }
    
    /*
    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                 print("breakpoint 8 - MstrVC - segue to DetailView")
                 let list = lists[indexPath.row]
                 controller.list = [list]
            }
        }
    }
    */
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        //return .fullScreen
        return .none
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MasterViewController: DataEntryControllerDelegate {
    func didAddNewData() {
        loadDataFromCoreData()
        self.tableView.reloadData()
    }
    
}
