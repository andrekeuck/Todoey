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
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist") //set dataFilePath to use the native file manager to check a URL that specifies the document directory within the user's Library structure on their computer. Look in the "Items.plist" file by appending that filename to the end of the directory path, and then Grab the ".first" item since it's an array.
    
//    let defaults = UserDefaults.standard //create an entry point to the User Defaults singleton, which stores persistent data across loading sessions of the app
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(dataFilePath!) //show me the file path for the plist
        loadItems() //call the load items function written below
        
    }

    //MARK - Tableview Datasource Methods
    
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
        
        saveItems() //call function saveItems, defined below
        
        tableView.deselectRow(at: indexPath, animated: true) //activates the gray highlight when the item is selected, but animates the de-selection immediately so the item is only highlighted during the tap/interaction
        
    }
    
    //MARK: Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField() //define a variable that is global within the addButtonPressed IBAction that you're in
        
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert) //create an alert pop-up with the specified title, message, and style
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in //set the title/label value for a button on the alert, choose its style, and define the action to take place once that button is tapped/pressed
            
            //what will happen once the user taps the Add Item button on our UIAlert

            let newItem = Item() //create newItem of type Item (see Item.swift class)
            newItem.title = textField.text! //set the title of the new Item instance to the text field entered by the user
            
            self.itemArray.append(newItem) //add the entered text to the item array established at the top of the code

            self.saveItems() //save the item according to the saveItems function defined below
            
        }
        
        alert.addTextField { (alertTextField) in //create a local variable called alertTextField to capture the entered item; the alertTextField variable here is local to the closure
            alertTextField.placeholder = "Create new item" //set the placeholder text of the alertTextField box
            textField = alertTextField //set the global variable established above to the value entered into the local/closure variable set above
            
        }
        
        alert.addAction(action) //add the action to the alert pop-up; i.e. insert the button and its corresponding action defined above into the alert pop-up defined above
        present(alert, animated: true, completion: nil) //display the alert (now with action inserted) using animation, and define the block to execute after the presentation is completed
        
    }
    
    func saveItems() { //function to write/save items to the plist
        let encoder = PropertyListEncoder() //set constant encoder to the P(roperty)ListEncoder
        
        do {
            let data = try encoder.encode(itemArray) //pass contents of itemArray to the encoder for encoding
            try data.write(to: dataFilePath!) //try to write the data to the destination file path specified above
        } catch {
            print("error encoding itemArray, \(error)") //show any errors
        }
        self.tableView.reloadData() //reload the tableview to display the updated array/data

    }
    
    func loadItems() { //function to load items that've been written to the plist
        if let data = try? Data(contentsOf: dataFilePath!) { //fetch the content from the P(roperty)List at the destination file path
            let decoder = PropertyListDecoder() //decode the content
            do {
                itemArray = try decoder.decode([Item].self, from: data) //for each array item, decode and present the properties
            } catch {
                print("Error decoding item array, \(error)") //show errors
        }
    }
    
    
}
}
