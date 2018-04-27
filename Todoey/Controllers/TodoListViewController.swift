//
//  ViewController.swift
//  Todoey
//
//  Created by Andre Keuck on 4/26/18.
//  Copyright © 2018 Andre Keuck. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [Item]() //create the array to hold the to-do items
    
    let defaults = UserDefaults.standard //create an entry point to the User Defaults singleton, which stores persistent data across loading sessions of the app
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let newItem = Item()
        newItem.title = "Find Mike"
        itemArray.append(newItem)

        let newItem2 = Item()
        newItem2.title = "Buy waffles."
        itemArray.append(newItem2)

        let newItem3 = Item()
        newItem3.title = "Destroy monster."
        itemArray.append(newItem3)
        
        if let items = defaults.array(forKey: "TodoListArray") as? [Item] { //set an if statement to check/set a local variable "items" equal to the key value pairs for TodoListArray which is stored in the User Defaults singleton, and cast the values as strings
            itemArray = items //copy the contents of "items" over to the ItemArray array for display on the screen
        }
        
        
    }

    //MARK - Tableview Datasource Methods
    
    //2 methods

    //how many rows we want in table view
    //TODO: Declare numberOfRowsInSection here:
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //FUNCTION SPECIFIES WHAT EACH ROW SHOULD DISPLAY
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { //declare swift function
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath) //set the cell equal to the value of "ToDoItemCell", the section of the TodoListViewController where tasks show up
        
        let item  = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title //set the text label of the entry equal to the array value at the index location
        
        cell.accessoryType = item.done ? .checkmark : .none //ternary operator to replace if/else statement; if item.done is TRUE (i.e. done), set accessoryType to checkmark, if item.done is FALSE (i.e. NOT done) set accessoryType to none
        
        return cell //display the cell with the value set above
    }
        
    //MARK - Create TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { //the function that defines what happens to a row that gets selected/tapped by the user
        //print(itemArray[indexPath.row])
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done //reverse the (boolean) value of the .done property for a given item at indexPath.row
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true) //activates the gray highlight when the item is selected, but animates the de-selection immediately so the item is only highlighted during the tap/interaction
        
    }
    
    //MARK: Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField() //define a variable that is global within the addButtonPressed IBAction that you're in
        
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert) //create an alert pop-up with the specified title, message, and style
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in //set the title/label value for a button on the alert, choose its style, and define the action to take place once that button is tapped/pressed
            
            //what will happen once the user taps the Add Item button on our UIAlert


            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem) //add the entered text to the item array established at the top of the code
            
            self.defaults.set(self.itemArray, forKey: "TodoListArray") //save the newly updated itemArray to the User Defaults in a Key-Value Pair format
            
            self.tableView.reloadData() //reload the tableview to display the updated array/data
        }
        
        alert.addTextField { (alertTextField) in //create a local variable called alertTextField to capture the entered item; the alertTextField variable here is local to the closure
            alertTextField.placeholder = "Create new item" //set the placeholder text of the alertTextField box
            textField = alertTextField //set the global variable established above to the value entered into the local/closure variable set above
            
        }
        
        alert.addAction(action) //add the action to the alert pop-up; i.e. insert the button and its corresponding action defined above into the alert pop-up defined above
        present(alert, animated: true, completion: nil) //display the alert (now with action inserted) using animation, and define the block to execute after the presentation is completed
        
    }
    
}
