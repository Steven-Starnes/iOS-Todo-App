//
//  TodoInputTextTableViewCell.swift
//  Todo
//
//  Created by Steven Starnes on 7/26/17.
//  Copyright © 2017 Steven Starnes. All rights reserved.
//

import UIKit

protocol AddTodoToList: class {
    func addTodoToList(todo: TodoItem)
}

class TodoInputTextTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBOutlet weak var todoInputText: UITextField!
    @IBOutlet weak var addTodoButton: UIButton!
    weak var addTodoDelegate: AddTodoToList?
    
    //If the input changes check to see if there is text and show the add button
    @IBAction func todoInputChanged(_ sender: UITextField) {
        if sender.text?.isEmpty == false {
            addTodoButton.isHidden = false;
            addTodoButton.isEnabled = true;
        } else {
            addTodoButton.isHidden = true;
            addTodoButton.isEnabled = false;
        }
    }
    
    
    //Add the todo to the data base
    @IBAction func addTodoListButton(_ sender: UIButton) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let todo = TodoItem(context: context)
        
        todo.todoItem = todoInputText.text
        todo.dateAdded = NSDate()
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()

        //Update the table view with a delegate
        addTodoDelegate!.addTodoToList(todo: todo)
        todoInputText.text = ""
        todoInputText.resignFirstResponder()
        
    }
}
