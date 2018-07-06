//
//  CategoryViewController.swift
//  Todoey
//
//  Created by William Soliman on 5/7/18.
//  Copyright © 2018 William Soliman. All rights reserved.
//

import UIKit
import RealmSwift

// Replace the conventional UIViewController with a UITableViewController
// Delegate and datasource declarations for the table view may be omitted
class CategoryViewController: UITableViewController {
    
    // Initialise an access point to our Realm database
    let realm = try! Realm()
    
    // "Results" is an auto-updating container type in Realm; unlike an array, you do not need to append new items to it when creating new data
    var categories : Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }

    //MARK: - TableView DataSource Methods
    
    // This method gets triggered when the tableview is generated
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Return the number of categories as the number of rows
        // Use the Nil Coalescing Operator; when categories has a value, then return its count; otherwise, return 1
        return categories?.count ?? 1
    }
    
    // This method gets triggered when the tableview is generated
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Specify the cell for any given row of the table view
        // The identifier is visible in the Attributes inspector (after clicking on "Prototype Cells" in the storyboard)
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        // Assign the "name" property of the given Category object to fill the cell's text label
        // Use the Nil Coalescing Operator; when categories has a value, then return the value at indexPath.row; otherwise, return custom String to the single cell
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet"
        
        return cell
        
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            
            // Set the selectedCategory property inside TodoListViewController, to correspond to that which was selected
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
        
    }
    
    //MARK: - Add New Categories
    
    // This method gets triggered when you press the add ('+') button in the top-right corner
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add A New Category", message: "", preferredStyle: .alert)
        
        // When we click the "Add Category" button, then create a new Category object, and assign the text field contents to its "name" property
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textField.text!
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
        
        // Perform "read" operation
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
        
    }
    
}
