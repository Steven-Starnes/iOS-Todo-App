//
//  TodoListsTableViewController.swift
//  Todo
//
//  Created by Steven Starnes on 7/20/17.
//  Copyright © 2017 Steven Starnes. All rights reserved.
//

import UIKit
import CoreData

class TodoListsTableViewController: UITableViewController, UpdateTableView {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Grab the todo lists and reload the table
        getTodoLists()
        tableView.reloadData()
    }

    //Grab the core data database for the app
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func getTodoLists() {
        do{
            let todoListFetch = NSFetchRequest<TodoList>(entityName: "TodoList")
            
            let sortDescriptor = NSSortDescriptor(key: #keyPath(TodoList.dateAdded), ascending: true)
            todoListFetch.sortDescriptors = [sortDescriptor]
            
            todoLists = try context.fetch(todoListFetch)
            
        }catch{
            print("ERROR: \(error)")
        }
    }
    
    //remove delete editing from text input cell
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if !(indexPath.section == 1) {
            return .delete
        } else {
            return .none
        }
    }
    
    //Add swipe to delete for the todo lists
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            context.delete(todoLists[indexPath.row])
            do {
                try context.save()
                getTodoLists()
                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            } catch {
                print("ERROR DELETING OBJECT: \(error)")
            }
        }
    }
    
    // MARK: - Table view data source

    //Two sections. One for lists and the other for adding lists
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    
    var todoLists: [TodoList] = []
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section) {
            case 0:
                return todoLists.count
            default:
                return 1
        }
    }

    //Fill the apropriate sections with the table view cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "todoListInputCell", for: indexPath) as! TodoListInputTextTableViewCell
            cell.updateTableDelegate = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "todoListCell", for: indexPath)

            cell.textLabel?.text = todoLists[indexPath.row].listName
            return cell
        }
    }

    
    //Reload the table view
    func reloadTableView() {
        getTodoLists()
        tableView.insertRows(at: [ IndexPath(row: todoLists.count - 1, section:0)], with: .automatic)

    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "todosSegue" {
            let selectedList: TodoList = todoLists[tableView.indexPathForSelectedRow!.row]
            let vc = segue.destination as? TodosTableViewController
            vc?.todoList = selectedList
        }

    }
    

    
}
