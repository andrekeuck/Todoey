//
//  ViewController.swift
//  Todoey
//
//  Created by Andre Keuck on 4/26/18.
//  Copyright © 2018 Andre Keuck. All rights reserved.
//

import UIKit
import CoreData


class TodoListViewController: UITableViewController {

    var itemArray = [Item]() //create the array to hold the to-do items
    
    var selectedCategory : Category? { //create a variable of type Category (optional) that gets set by the CategoryViewController when a category is chosen and passed to this VC.
        didSet { //this code will trigger only when Category is assigned a value
            loadItems() //call the load items function written below
        }
        
    }
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext //create constant called context; access UIApplication class, getting the shared singleton object which corresponds to the current App, as an object, tapping into its delegate which is an optional UI delegate, casting it to our class (AppDelegate) ALL to get access to the contents of our AppDelegate, which contains persistentContainer which we need.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { //the function that defines what happens to a row that gets selected by the user
  
//        context.delete(itemArray[indexPath.row]) //delete the selected item from the context AND THEN
//        itemArray.remove(at: indexPath.row) //remove the selected item from the screen **Delete THEN remove** and then execute saveItems to commit the changes
        
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done //reverse the (boolean) value of the .done property for a given item at indexPath.row
        
        saveItems() //call function saveItems, defined below
        
        tableView.deselectRow(at: indexPath, animated: true) //activates the gray highlight when the item is selected, but animates the de-selection immediately so the item is only highlighted during the tap/interaction
    }
    
//MARK: Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField() //define a variable that is global within the addButtonPressed IBAction that you're in
        
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert) //create an alert pop-up with the specified title, message, and style
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in //set the title/label value for a button on the alert, choose its style, and define the action to take place once that button is tapped/pressed
            
            //what will happen once the user taps the Add Item button on our UIAlert:
            let newItem = Item(context: self.context) //create newItem of type Item
            newItem.title = textField.text! //set the title of the new Item instance to the text field entered by the user
            newItem.done = false //set the "done" attribute to false/not done by default
            newItem.parentCategory = self.selectedCategory //set the parentCategory attribute (a link to the relationship between item and category in the data model) to the selectedCategory variable specified above, i.e. the category selected in the CategoryViewController and passed to this VC
            
            self.itemArray.append(newItem) //add the entered text to the item array established earlier up top

            self.saveItems() //save the item according to the saveItems function defined below
        }
        
        alert.addTextField { (alertTextField) in //create a local variable called alertTextField to capture the entered item; the alertTextField variable here is local to the closure
            alertTextField.placeholder = "Create new item" //set the placeholder text of the alertTextField box
            textField = alertTextField //set the global variable established above to the value entered into the local/closure variable set above
            
        }
        
        alert.addAction(action) //add the action to the alert pop-up; i.e. insert the button and its corresponding action defined above into the alert pop-up defined above
        present(alert, animated: true, completion: nil) //display the alert (now with action inserted) using animation, and define the block to execute after the presentation is completed
    }
    
    func saveItems() { //function to write/save items to the database
        
        do {
            try context.save() //saves the currently-engaged Item in the context
        } catch {
            print("Error saving context \(error)")
        }
        self.tableView.reloadData() //reload the tableview to display the updated array/data
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) { //function to load items that've been written to the database, and assigning a default value to show all items in the applicable database view (i.e. all of the to-do items)
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!) //set predicate to the set of elements whose category is set to the selected category specified above and by the category VC
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do { //do/catch block to fetch database content
            itemArray = try context.fetch(request) //execute a fetch on the "request" constant, which is assigned to hold Item-entity data
        }
        catch {
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
}


//MARK: Search bar methods
    extension TodoListViewController: UISearchBarDelegate { //create a specialized "extension" modular section of the code to add specific/discrete functionality

        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) { //take whatever has been entered into the search bar such that "searchBar.text" = the text contents
            let request : NSFetchRequest<Item> = Item.fetchRequest() //create constant "request", declare the data type, set the type of the returned content, and set it equal to the fetch command
            
            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!) //check out https://academy.realm.io/posts/nspredicate-cheatsheet/ for more info
            
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)] //sort results in alphabetical order

            loadItems(with: request, predicate: predicate)
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) { //activate this when text changes; only triggers if there's text that changes--not if it's blank and gets text added
            if searchBar.text?.count == 0 { //if the number of characters equals 0 during a change to text
                loadItems() //call loadItems
                
                DispatchQueue.main.async {
                    searchBar.resignFirstResponder()
                }
            }
        }
        
    }
    

    
    


