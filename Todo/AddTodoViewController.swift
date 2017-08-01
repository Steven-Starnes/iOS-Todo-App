//
//  AddTodoViewController.swift
//  Todo
//
//  Created by Steven Starnes on 7/23/17.
//  Copyright © 2017 Steven Starnes. All rights reserved.
//

import UIKit

class AddTodoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    var todoList: TodoList?
    
    @IBOutlet weak var todoName: UITextField!

    @IBAction func addTodoButton(_ sender: UIButton) {
        print(todoList?.listName ?? "")
        
        let container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let todo = TodoItem(context: container)
        
        todo.todoItem = todoName.text
        todo.dateAdded = NSDate()
        
        todoList?.addToTodos(todo)
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        let _ = navigationController?.popViewController(animated: true)
        
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
