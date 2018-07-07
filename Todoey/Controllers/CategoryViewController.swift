//
//  CategoryViewController.swift
//  Todoey
//
//  Created by William Soliman on 5/7/18.
//  Copyright © 2018 William Soliman. All rights reserved.
//

import UIKit

// RealmSwift (CocoaPod) enables persistent data storage on the device
import RealmSwift

// ChameleonFramework (CocoaPod) facilitates editing of colours in the interface
import ChameleonFramework

// Replace the conventional UIViewController with our custom SwipeTableViewController (which itself inherits from UITableViewController)
// Delegate and datasource declarations for the table view may be omitted
class CategoryViewController: SwipeTableViewController {
    
    // Initialise an access point to our Realm database
    let realm = try! Realm()
    
    // "Results" is an auto-updating container type in Realm; unlike an array, you do not need to append new items to it when creating new data
    var categories : Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
        tableView.separatorStyle = .none
        
    }

    //MARK: - TableView DataSource Methods
    
    // This method gets triggered when the tableview is generated
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Return the number of categories (line items / rows in the database) as the number of rows in the table view
        // Use the Nil Coalescing Operator - i.e. when categories has a value, then return its count; otherwise, return 1
        return categories?.count ?? 1
    }
    
    // This method gets triggered when the tableview is generated
    // It overrides what was already added in the superclass (namely the specification of the cell for each row)
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Tap into the cell that is defined in the superclass
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        // Assign the "name" property of the given Category object to fill the cell's text label
        // Use the Nil Coalescing Operator - i.e. when categories has a value, then return the "name" value at indexPath.row; otherwise, return a custom String to the single cell that exists
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet"
        
        // Assign the "colour" property of the given Category object to fill the cell's background
        cell.backgroundColor = UIColor(hexString: categories?[indexPath.row].colour ?? "1D9BF6")
        
        // Let ChameleonFramework decide whether black or white font offers a better contrast to the background color
        // Note that "guard let" is an alternative to "if let" optional binding, to ensure that categories?... is not nil
        guard let categoryColour = UIColor(hexString: categories?[indexPath.row].colour) else {fatalError()}
        
        cell.textLabel?.textColor = UIColor.init(contrastingBlackOrWhiteColorOn: categoryColour, isFlat: true)
        
        return cell
        
    }
    
    //MARK: - TableView Delegate Methods
    
    // This method gets triggered when a row is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    // This method gets triggered just before the segue is performed
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            
            // Set the selectedCategory property inside TodoListViewController, to correspond to that which was selected in CategoryViewController
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
        
    }
    
    //MARK: - Add New Categories
    
    // This method gets triggered when you press the add ('+') button in the top-right corner of CategoryViewController
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add A New Category", message: "", preferredStyle: .alert)
        
        // When we click on "Add Category" ...
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            // Create a new Category object
            let newCategory = Category()
            
            // Assign the text field contents to its "name" property
            newCategory.name = textField.text!
            
            // Generate the hex value of a random color (using ChameleonFramework) and assign it to its "colour" property
            newCategory.colour = UIColor.randomFlat().hexValue()
            
            // Add the new category to our realm (as a new "row" in the database)
            self.save(category: newCategory)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Data Manipulation Methods
    
    // This method gets called by UIAlertAction()
    func save(category: Category){
        do {
            // Perform "create" operation - "realm.write" commits changes to our Realm database
            try realm.write() {
                realm.add(category)
            }
        } catch {
            print("Error saving context \(error)")
        }
        
        tableView.reloadData()
    }
    
    // This method gets called by viewDidLoad()
    func loadCategories(){
        
        // Perform "read" operation - "realm.objects()" extracts all line items / rows in the database and assigns them to "categories" (our container/list/array of Results)
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
        
    }
    
    // This method gets called when you click the "Delete" button after swiping a cell
    // This method is defined in the subclass, since the superclass does not know about "categories" or "toDoItems"
    override func updateModel(at indexPath: IndexPath){
        
        if let deletedCategory = categories?[indexPath.row] {
            
            // Note that, even though we "delete" a category, we must still perform a "write" operation on the realm
            do {
                try realm.write() {
                    realm.delete(deletedCategory)
                }
            } catch {
                print("Error deleting category, \(error)")
            }

        }
    }
    
}
