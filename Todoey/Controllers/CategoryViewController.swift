//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Andre Keuck on 4/30/18.
//  Copyright © 2018 Andre Keuck. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm() //initialize the realm database with the realm constant
    
    var categories : Results<Category>? //create a categoryArray of Category items as defined in the Data Model
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories() //call the loadCategories function written below
    }

//MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories?.count ?? 1 //the nil coalescing operator; get the count of categories if != nil; if nil just use 1 instead
    }
    
    //FUNCTION SPECIFIES WHAT EACH ROW SHOULD DISPLAY
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { //declare swift function
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) //set the cell equal to the value of "CategoryCell", the section of the CategoryViewController where tasks show up
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added" //set the text label of the entry equal to the value at the index location; if it's nil just set it to the default language
        
        return cell //display the cell with the value set above
    }

//MARK: - TableView Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { //the function that defines what happens to a row that gets selected by the user
        performSegue(withIdentifier: "goToItems", sender: self) //execute the segue called "goToItems" that we specified earlier, which points to the TodoListViewController that contains the task items
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { //function executed immediately before the segue (referenced above) is executed--this all ONLY happens AFTER a row is selected
        let destinationVC = segue.destination as! TodoListViewController //set destinationVC equal to whatever the segue's destination is, which in this case is downcast ("as!") as the known TodoListViewController.
        
            //IF there were multiple segues off this Viewcontroller (i.e. multiple possible destinations) you could/would use an if statement to say "if identifier equals X, go to VC-X, if identifier equals Y, go to VC-Y, etc...)
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row] //set the selectedCategory property to the content of the row selected
        }
    
    }
    
    
    
    
    
    
//MARK: - Data Manipulation Methods
    func save(category: Category) { //function to write/save categories to the database
        
        do {
            try realm.write { //initiate writing
                realm.add(category) //add the content of category to the database
            } //saves the currently-engaged Item in the context
        } catch {
            print("Error saving context \(error)")
        }
        self.tableView.reloadData() //reload the tableview to display the updated array/data
    }
    
    func loadCategories() { //function to load Categories that've been written to the database, and assigning a default value to show all Categories in the applicable database view (i.e. all of the to-do Categories)

        categories = realm.objects(Category.self) //call up all the category elements of type category, thus "self"
        
        tableView.reloadData()
    }
    
//MARK: - Add New Categories using IBAction
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField() //define a variable that is global within the addButtonPressed IBAction that you're in
        
        let alert = UIAlertController(title: "Add new  Category", message: "", preferredStyle: .alert) //create an alert pop-up with the specified title, message, and style
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in //set the title/label value for a button on the alert, choose its style, and define the action to take place once that button is tapped/pressed

            //what will happen once the user taps the Add  button on our UIAlert:
            let newCategory = Category() //create newCategory of type Category
            newCategory.name = textField.text! //set the title of the new Item instance to the text field entered by the user
            
            self.save(category: newCategory) //save the category according to the saveCategories function defined below
        
        }

        alert.addAction(action) //add the action to the alert pop-up; i.e. insert the button and its corresponding action defined above into the alert pop-up defined above

        alert.addTextField { (alertTextField) in //create a local variable called alertTextField to capture the entered item; the alertTextField variable here is local to the closure
            alertTextField.placeholder = "Create new item" //set the placeholder text of the alertTextField box
            textField = alertTextField //set the global variable established above to the value entered into the local/closure variable set above
        }
        
        present(alert, animated: true, completion: nil) //display the alert (now with action inserted) using animation, and define the block to execute after the presentation is completed
    }

    

    
}

