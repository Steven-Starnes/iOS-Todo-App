//
//  TodoListInputTextTableViewCell.swift
//  Todo
//
//  Created by Steven Starnes on 7/26/17.
//  Copyright © 2017 Steven Starnes. All rights reserved.
//

import UIKit

protocol UpdateTableView: class {
    func reloadTableView()
}

class TodoListInputTextTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBOutlet weak var todoListInputText: UITextField!
    @IBOutlet weak var addListButton: UIButton!
    weak var updateTableDelegate: UpdateTableView?
    
    //If the input changes check to see if there is text and show the add button
    @IBAction func todoListInputChanged(_ sender: UITextField) {
        if sender.text?.isEmpty == false {
            addListButton.isHidden = false;
            addListButton.isEnabled = true;
        } else {
            addListButton.isHidden = true;
            addListButton.isEnabled = false;
        }
    }

    //Add the todo list to the database
    @IBAction func addTodoListButton(_ sender: UIButton) {
        let container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let todoList = TodoList(context: container)
        
        todoList.listName = todoListInputText.text
        todoList.dateAdded = NSDate()
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        //Update the table view with a delegate 
        updateTableDelegate!.reloadTableView()
        todoListInputText.text = ""
        todoListInputText.resignFirstResponder()

        
    }
}
