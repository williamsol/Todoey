//
//  ViewController.swift
//  Todoey
//
//  Created by William Soliman on 2/7/18.
//  Copyright © 2018 William Soliman. All rights reserved.
//

import UIKit

// Replace the conventional UIViewController with a UITableViewController
// Delegate and datasource declarations for the table view may be omitted
class TodoListViewController: UITableViewController {

    // Declare an array of Item objects ("Item" refers to our Data Model, which has "title" and "done" fields)
    var itemArray = [Item]()
    
    // Create a UserDefaults to persistently store data (i.e. even when the app terminates)
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item()
        newItem.title = "Find Mike"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Buy Eggos"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Destroy Demogorgon"
        itemArray.append(newItem3)
        
        // Retrieve the array that is stored in UserDefaults
        // Data is stored in UserDefaults every time we create a new item
        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
            itemArray = items
        }
        
    }
    
    //MARK - TableView DataSource Methods
    
    // This method gets triggered when the tableview is generated
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Set number of rows equal to number of items in the array
        return itemArray.count
        
    }
    
    // This method gets triggered when the tableview is generated
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Specify the cell for any given row of the table view
        // The identifier is visible in the Attributes inspector (after clicking on "Prototype Cells" in the storyboard)
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        // Label the cell with the "title" property of the item object
        cell.textLabel?.text = item.title
        
        // Add a checkmark if the "done" property of the item object is "true"
        // Note that this line makes use of the Ternary operator (instead of an if-else statement); the condition that is being tested is "item.done == true"
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
        
    }
    
    //MARK - TableView Delegate Methods
    
    // This method gets triggered when you select any row in the tableview
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(itemArray[indexPath.row])
        
        // Toggle a checkmark next to the selected cell (note that the checkmark accessory may be added to the ToDoItemCell under the Attributes inspector)
        // This information gets stored in the "done" field of the respective Item object in itemArray
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        } else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        
        // Re-trigger the tableView(... cellForRowAt ...) delegate method to update checkmarks
        tableView.reloadData()
        
        // Avoid the selected row from remaining highlighted (by deselecting it)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }

    //MARK - Add New Items
    
    // This method gets triggered when you press the add ('+') button in the top-right corner
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            // When the user clicks on the Add Item button, store the text field contents in the "title" property of a new Item object, and append this object to our Item array
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            
            // Store the itemArray in UserDefaults under the key "TodoListArray"
            // This array will be retrieved upon viewDidLoad()
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            // Reload the table view to display the updated data in the updated itemArray
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            // Note that the scope of alertTextField is confined to this closure; we need the textField variable, so that we can append its contents to the array once the user clicks the Add Item button (above)
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
}

