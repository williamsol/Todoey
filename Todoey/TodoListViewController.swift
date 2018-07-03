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

    var itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"]
    
    // Create a UserDefaults to persistently store data (i.e. even when the app terminates)
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Retrieve the array that is stored in UserDefaults upon creating a new item
        if let items = defaults.array(forKey: "TodoListArray") as? [String] {
            itemArray = items
        }
    }
    
    //MARK - TableView DataSource Methods
    
    // Set number of rows equal to number of items in the array
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
        
    }
    
    // Specify the cell for each row in the table view
    // The identifier of the cell is specified in the Attributes inspector (after clicking on "Prototype Cells" in the storyboard)
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
        
    }
    
    //MARK - TableView Delegate Methods
    
    // When a given row is selected, print its contents
    // Avoid the selected row from remaining highlighted (by deselecting it)
    // Toggle a checkmark next to the selected cell (note that the checkmark accessory may be added to the ToDoItemCell under the Attributes inspector)
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(itemArray[indexPath.row])
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // When the user clicks the Add Item button, append the contents of the text field to our array
            self.itemArray.append(textField.text!)
            
            // Store the array in the UserDefaults under the key "TodoListArray"
            // These data will be assigned to the array upon viewDidLoad()
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            // Reload the table view to display the array contents
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

