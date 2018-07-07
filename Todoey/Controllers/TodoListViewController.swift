//
//  ViewController.swift
//  Todoey
//
//  Created by William Soliman on 2/7/18.
//  Copyright © 2018 William Soliman. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    var toDoItems: Results<Item>?
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory : Category? {
        
        // "didSet" specifies what should happen when the variable selectedCategory is set with a new value - this happens in prepare(for segue: ...) in CategoryViewController
        didSet{
            
            // Retrieve the toDoItems, once a category has been selected
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        
    }
    
    // viewWillAppear() is called shortly after viewDidLoad()
    // We cannot edit the navigation controller in viewDidLoad(), because ToDoListViewController may not yet have been added to the navigation stack at that point
    override func viewWillAppear(_ animated: Bool) {
        
        guard let colourHex = selectedCategory?.colour else { fatalError() }
        
        // Update the nav bar with the colour associated with the selected category
        updateNavBar(withHexCode: colourHex)
        
        // Change the title to match the name of the selected category
        title = selectedCategory?.name
        
    }
    
    // viewWillDisappear() is called just before a view is removed (by hitting the back button)
    override func viewWillDisappear(_ animated: Bool) {
        
        // Update the nav bar with the default colour
        updateNavBar(withHexCode: "1D9BF6")
        
    }
    
    //MARK: - Nav Bar Setup Methods
    
    func updateNavBar(withHexCode colourHexCode: String) {
        
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist.")}
        
        guard let navBarColour = UIColor(hexString: colourHexCode) else { fatalError() }
        
        // Set the colour of the navigation bar
        navBar.barTintColor = navBarColour
        
        // Set the font color of the '+' sign to contrast that of the navigation bar
        navBar.tintColor = UIColor.init(contrastingBlackOrWhiteColorOn: navBarColour, isFlat: true)
        
        // Set the font color of the navigation bar title to contrast that of the navigation bar
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.init(contrastingBlackOrWhiteColorOn: navBarColour, isFlat: true)]
        
        // Set the color of the search bar to match that of the navigation bar
        searchBar.barTintColor = navBarColour
        
    }
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return toDoItems?.count ?? 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = toDoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            // Set the background colour to the colour associated with the selected category, but darkened by a percentage that depends on the row of the cell
            if let colour = UIColor(hexString: selectedCategory!.colour)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(toDoItems!.count)) {
                
                cell.backgroundColor = colour
                
                // Let ChameleonFramework decide whether black or white font offers a better contrast to the background color
                cell.textLabel?.textColor = UIColor.init(contrastingBlackOrWhiteColorOn: colour, isFlat: true)
                
            }
            
            // Add a checkmark if the "done" property is "true"
            // Note that this line makes use of the Ternary operator (as a shorter alternative to an if-else statement); the condition that is being tested here is "item.done == true"
            cell.accessoryType = item.done ? .checkmark : .none
            
        } else {
            
            cell.textLabel?.text = "No items added"
            
        }
        
        return cell
        
    }
    
    //MARK: - TableView Delegate Methods
    
    // This method gets triggered when you select any row in the tableview
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = toDoItems?[indexPath.row] {
            do {
                try realm.write {
                    // Toggle the "done" property of the relevant item
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        
        tableView.reloadData()
        
        // Avoid the selected row from remaining highlighted (by deselecting it)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }

    //MARK: - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        
                        // Append newItem to the selectedCategory's "items" list
                        // Note that we are not making use of "realm.add(...)" here, as we did in CategoryViewController
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new items, \(error)")
                }
            }
            
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Model Manipulation Method
    
    // This method gets called once a category is selected
    func loadItems() {

        // Load all items associated with the selected category and sort them alphabetically by title
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    }
    
    // This method gets called when you click the "Delete" button after swiping a cell
    // This method is defined in the subclass, since the superclass does not know about "categories" or "toDoItems"
    override func updateModel(at indexPath: IndexPath){
        
        if let deletedItem = toDoItems?[indexPath.row] {
            
            do {
                try realm.write {
                    realm.delete(deletedItem)
                }
            } catch {
                print("Error deleting Item, \(error)")
            }
            
        }
    }
    
}

//MARK: - Search Bar Methods

// We can use an "extension" to separate out certain functionalities inside the view controller
extension TodoListViewController: UISearchBarDelegate {

    // Filter items based on the text inside the search bar, and sort them by the date on which they were created
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()

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
