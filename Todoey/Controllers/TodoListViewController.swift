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
    
    // Create a file path to the documents folder, and create a custom .plist file
    // This path will be unique for a particular app on a particular device
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Retrieve the data that is stored in dataFilePath
        loadItems()
        
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
        
        // Store itemArray in the Items.plist file that is referenced by dataFilePath
        // This array will be retrieved upon viewDidLoad()
        // saveItems() also reloads the table view to reflected the updated data in ItemArray
        saveItems()
        
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        } else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        
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
            
            // Store itemArray in the Items.plist file that is referenced by dataFilePath
            // This array will be retrieved upon viewDidLoad()
            // saveItems() also reloads the table view to reflected the updated data in ItemArray
            self.saveItems()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            // Note that the scope of alertTextField is confined to this closure; we need the textField variable, so that we can append its contents to the array once the user clicks the Add Item button (above)
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK - Model Manipulation Method
    
    // This method gets called by tableView(... didSelectRowAt ...) and by addButtonPressed(...)
    func saveItems() {
        
        let encoder = PropertyListEncoder()
        
        // Note that encoder.encode() and data.write() can throw errors, so we need to use a do-catch block
        do {
            // Try to encode the data
            let data = try encoder.encode(itemArray)
            // Try to write the encoded data to Items.plist
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding item array, \(error)")
        }
        
        // Reload the table view to reflect the updated data in itemArray
        // This re-triggers the delegate method tableView(... cellForRowAt ...)
        tableView.reloadData()
    }
    
    // This method gets called by viewDidLoad()
    func loadItems() {
        
        // Use optional binding to safely unwrap the Swift optional
        if let data = try? Data(contentsOf: dataFilePath!) {
            
            let decoder = PropertyListDecoder()
            
            // Note that decoder.decode() can throw an error, so we need to use a do-catch block
            do {
                // Try to decode the data, of specified data type [Item]
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding item array, \(error)")
            }
        }
    }
    
}

