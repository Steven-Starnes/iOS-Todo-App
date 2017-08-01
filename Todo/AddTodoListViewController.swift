//
//  AddTodoListViewController.swift
//  Todo
//
//  Created by Steven Starnes on 7/20/17.
//  Copyright © 2017 Steven Starnes. All rights reserved.
//

import UIKit
import CoreData

class AddTodoListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var todoListName: UITextField!

    
    @IBAction func addTodoListButton(_ sender: UIButton) {
        let container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let todoList = TodoList(context: container) 
        
        todoList.listName = todoListName.text
        todoList.dateAdded = NSDate()
        
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
