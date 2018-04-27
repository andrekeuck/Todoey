//
//  ViewController.swift
//  Todoey
//
//  Created by Andre Keuck on 4/26/18.
//  Copyright © 2018 Andre Keuck. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"] //create the array to hold the to-do items
    
    let defaults = UserDefaults.standard //create an entry point to the User Defaults iOS backend database which stores persistent data across loading sessions of the app
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let items = defaults.array(forKey: "TodoListArray") as? [String] { //set an if statement to check/set a local variable "items" equal to the key value pairs for TodoListArray which is stored in the User Defaults database, and cast the values as strings
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
        
        cell.textLabel?.text = itemArray[indexPath.row] //set the text label of the entry equal to the array value at the index location
        
        return cell //display the cell with the value set above
    }
        
    //MARK - Create TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { //the function that defines what happens to a row that gets selected/tapped by the user
        //print(itemArray[indexPath.row])
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark { //check to see if the selected row has already been selected, i.e. if .accessoryType is assigned to "checkmark"
            tableView.cellForRow(at: indexPath)?.accessoryType = .none //if .accessoryType HAS been assigned to checkmark, then reset .accessoryType to .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark //if it HAS NOT been selected, select it with a check mark; i.e. if .accessoryType is set to none, then assign it to .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true) //activates the gray highlight when the item is selected, but animates the de-selection immediately so the item is only highlighted during the tap/interaction
        
    }
    
    //MARK: Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField() //define a variable that is global within the addButtonPressed IBAction that you're in
        
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert) //create an alert pop-up with the specified title, message, and style
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in //set the title/label value for a button on the alert, choose its style, and define the action to take place once that button is tapped/pressed
            
            //what will happen once the user taps the Add Item button on our UIAlert
            self.itemArray.append(textField.text!) //add the entered text to the item array established at the top of the code
            
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
