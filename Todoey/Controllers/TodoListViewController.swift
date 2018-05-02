//
//  ViewController.swift
//  Todoey
//
//  Created by Andre Keuck on 4/26/18.
//  Copyright © 2018 Andre Keuck. All rights reserved.
//

import UIKit
import RealmSwift


class TodoListViewController: UITableViewController {

    var todoItems: Results<Item>? //create the array to hold the to-do items
    
    let realm = try! Realm() //initialize the realm database with the realm constant
    
    var selectedCategory : Category? { //create a variable of type Category (an optional) that gets set by the CategoryViewController when a category is chosen and passed to this VC.
        didSet { //this code will trigger only when Category is assigned a value
            loadItems() //call the load items function written below
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

//MARK - Tableview Datasource Methods
    
    //TODO: Declare numberOfRowsInSection here:
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1 //show as many cells as there are items
    }
    
    //FUNCTION SPECIFIES WHAT EACH ROW SHOULD DISPLAY
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { //declare swift function
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath) //set the cell equal to the value of "ToDoItemCell", the section of the TodoListViewController where tasks show up
        
        if let item  = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title //set the text label of the entry equal to the array value at the index location
            
            cell.accessoryType = item.done ? .checkmark : .none //ternary operator to replace if/else statement; if item.done is TRUE (i.e. done), set accessoryType to checkmark, if item.done is FALSE (i.e. NOT done) set accessoryType to none
        } else {
            cell.textLabel?.text = "No items added."
        }
        return cell //display the cell with the value set above
    }
        
//MARK - Create TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { //the function that defines what happens to a row that gets selected by the user
 
        if let item = todoItems?[indexPath.row] { //if todoItems is not nil, select item at indexPath.row and set it to equal item
            do {
                try realm.write { //record that item.done now gets its inverse (done -> not done, and vice versa)
                    item.done = !item.done
//                    realm.delete(item) //activate realm's delete function, pass it the item to be deleted
                }
            } catch {
                print("Error saving done status: \(error)")
            }
        }
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true) //activates the gray highlight when the item is selected, but animates the de-selection immediately so the item is only highlighted during the tap/interaction
    }
    
//MARK: Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            
            //what will happen once the user taps the Add Item button on our UIAlert:
           
            if let currentCategory = self.selectedCategory { //is our category nil?
                do {
                    try self.realm.write {
                        let newItem = Item() //create newItem of type Item
                        newItem.title = textField.text! //set the title of the new Item instance to the text field entered by the user
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                    } catch {
                        print("Error saving new items, \(error)")
                    }
                }
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in //create a local variable called alertTextField to capture the entered item; the alertTextField variable here is local to the closure
            alertTextField.placeholder = "Create new item" //set the placeholder text of the alertTextField box
            textField = alertTextField //set the global variable established above to the value entered into the local/closure variable set above
            
        }
        
        alert.addAction(action) //add the action to the alert pop-up; i.e. insert the button and its corresponding action defined above into the alert pop-up defined above
        present(alert, animated: true, completion: nil) //display the alert (now with action inserted) using animation, and define the block to execute after the presentation is completed
    }

    
    func loadItems() {

        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true) //items from the selectedCategory are presented by title, sorted in ascending order
        
        tableView.reloadData()
    }
}


//MARK: Search bar methods create a specialized "extension" modular section of the code to add specific/discrete functionality
    extension TodoListViewController: UISearchBarDelegate {
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

            todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true) //  https://academy.realm.io/posts/nspredicate-cheatsheet/ for more info
    
        tableView.reloadData()
        
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


    
    


