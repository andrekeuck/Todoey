//
//  ViewController.swift
//  Todoey
//
//  Created by Andre Keuck on 4/26/18.
//  Copyright © 2018 Andre Keuck. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    let itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    
    
   
    
    
    
    
    
    
 
}
