//
//  TodosTableViewController.swift
//  Todo
//
//  Created by Steven Starnes on 7/20/17.
//  Copyright © 2017 Steven Starnes. All rights reserved.
//

import UIKit
import CoreData

class TodosTableViewController: UITableViewController, AddTodoToList {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
 
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewWillAppear(_ animated: Bool) {
        //Grab the todos and reload the table view
        getTodos()
        tableView.reloadData()
    }


    var todoList: TodoList?
    
    var todos: [TodoItem] = []
    
    // MARK: - Table view data source

    //Two sections. One for todos and the other for adding todos
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return (todoList?.todos?.count)!
        } else {
            return 1
        }
    }

    //Fill the cells with the apropriate cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath)
            cell.textLabel?.text = todos[indexPath.row].todoItem
            if todos[indexPath.row].completed == true {
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: (cell.textLabel?.text)!)
                attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributeString.length))
                cell.textLabel?.attributedText = attributeString
                
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "todoInputCell", for: indexPath) as! TodoInputTextTableViewCell
            cell.addTodoDelegate = self
            return cell
        }
    }

    //remove delete editing from text input cell
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if (indexPath.section != 1) {
            return .delete
        } else {
            return .none
        }
    }
    
    
    func getTodos() {
        todos = todoList?.todos?.allObjects as! [TodoItem]
        todos.sort(by: {$0.dateAdded!.compare($1.dateAdded! as Date) == .orderedAscending})
    }
    
    //Add swipe to delete for todos
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context.delete(todos[indexPath.row])
            do {
                try context.save()
                tableView.reloadData()
            } catch {
                print("ERROR DELETING OBJECT: \(error)")
            }
        }
    }
    
    //Add strike throughs and check marks for completed todos
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section != 1 {
            let selectedTodo = todos[indexPath.row]
            let cell = tableView.cellForRow(at: indexPath)
            if selectedTodo.completed == true {
                
                selectedTodo.completed = false
                
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: (cell?.textLabel?.text)!)
                attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 0, range: NSMakeRange(0, attributeString.length))
                cell?.textLabel?.attributedText = attributeString
                
                cell?.accessoryType = .none
            } else {
                selectedTodo.completed = true
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: (cell?.textLabel?.text)!)
                attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributeString.length))
                cell?.textLabel?.attributedText = attributeString
                
                tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            }
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        }
    }

    func addTodoToList(todo: TodoItem) {
        todoList?.addToTodos(todo)
        getTodos()
        tableView.insertRows(at: [ IndexPath(row: todos.count - 1, section:0)], with: .automatic)
        
    }

}
