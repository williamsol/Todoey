//
//  ViewController.swift
//  Todoey
//
//  Created by William Soliman on 2/7/18.
//  Copyright © 2018 William Soliman. All rights reserved.
//

import UIKit
import CoreData

// Replace the conventional UIViewController with a UITableViewController
// Delegate and datasource declarations for the table view may be omitted
class TodoListViewController: UITableViewController {

    // Declare an array of Item objects (of type NSManagedObject, i.e. rows in the database)
    // "Item" refers to the entity in our Core Data model
    // This entity, and every object/row inside it, has 2 attributes ("title", "done")
    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        // didSet specifies what should happen when the variable selectedCategory gets set with a new value
        didSet{
            // Retrieve the data that is stored in the database, once a category is selected
            loadItems()
        }
    }
    
    // Define the context for Core Data
    // The context is a temporary area before committing to any change (creation, update, deletion) to the database
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
    print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        
    }
    
    //MARK: - TableView DataSource Methods
    
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
        
        // Label the cell with the "title" attribute of the item NSManagedObject
        cell.textLabel?.text = item.title
        
        // Add a checkmark if the "done" attribute of the item NSManagedObject is "true"
        // Note that this line makes use of the Ternary operator (instead of an if-else statement); the condition that is being tested is "item.done == true"
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
        
    }
    
    //MARK: - TableView Delegate Methods
    
    // This method gets triggered when you select any row in the tableview
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Toggle the checkmark attribute of the item NSManagedObject that was selected
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        // Save items and reload the table view
        saveItems()
        
        // Avoid the selected row from remaining highlighted (by deselecting it)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }

    //MARK: - Add New Items
    
    // This method gets triggered when you press the add ('+') button in the top-right corner
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        // We need a variable textField to first store the contents from alerTextField, and then assign this to the "title" attribute of the new NSManagedObject
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            // Create a new row (NSManagedObject) item and append it to the array
            // This will update the Context
            let newItem = Item(context: self.context)
            
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            
            // Commit the Context to the Permanent Container
            self.saveItems()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            // Note that the scope of alertTextField is confined to this closure, and therefore cannot be used to directly edit the new NSManagedObject
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Model Manipulation Method
    
    // This method gets called by tableView(... didSelectRowAt ...) and by addButtonPressed(...)
    func saveItems() {
        
        // We must save the Context to the Persistent Container in Core Data
        // Note that context.save() can throw an error, so we need to use a do-catch block
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        // Reload the table view to reflect the updated data in itemArray
        // This re-triggers the delegate method tableView(... cellForRowAt ...)
        tableView.reloadData()
    }
    
    // This method gets called by viewDidLoad() and by searchBarButtonClicked
    // "with" is the external/outside parameter; "request" is the internal/inside parameter
    // "Item.fetchRequest()" and "nil" are the default values if the method is called without arguments
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        // Retrieve all items that belong to the parent category and search terms (if any)
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        // Note that context.fetch() can throw an error, so we need to use a do-catch block
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }
    
}

// We can use an "extension" to separate out certain functionalities inside the view controller
//MARK: - Search bar methods
extension TodoListViewController: UISearchBarDelegate {
    
    // Load items based on text inside the search bar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
        
    }
    
    // Load (all) items when the search bar is cleared
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
    
}
