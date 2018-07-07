//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by William Soliman on 6/7/18.
//  Copyright © 2018 William Soliman. All rights reserved.
//

import UIKit

// SwipeCellKit (CocoaPod) enables category and item cells to be swiped (so that they can then be deleted)
import SwipeCellKit

// SwipeTableViewController is used as the superclass of CategoryViewController and ToDoListViewController
// CategoryViewController and ToDoListViewController inherit methods from SwipeTableViewController
class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the table view height in both CategoryViewController and ToDoListViewController, so that the "delete-icon" image is fully visible upon swiping
        tableView.rowHeight = 80
    }
    
    // TableView DataSource Methods
    
    // This method gets called whenever the table view is generated
    // It is overriden within the 2 child classes to add additional code (e.g. to fill the cells with category names or item titles)
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Specify the cell for any given row in the table view
        // The identifier is visible in the Attributes inspector (after clicking on "Prototype Cells" from within Main.storyboard)
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self
        
        return cell
        
    }

    // This delegate method originates from the documentation for SwipeCellKit on GitHub
    // This method makes a "delete-icon" image appear when you swipe a cell; the cell gets deleted when you click on the image
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            
            // This closure gets called when you click on the "Delete" button
            // We specify the deletion of the relevant category or item only from within the child classes - the superclass does not know about them
            self.updateModel(at: indexPath)
            
        }
        
        // Customize the appearance of the "Delete" button
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    // This delegate method originates from the documentation for SwipeCellKit on GitHub
    // This method deletes a cell when you swipe it all the way
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    
    // This method gets overridden within the subclasses, where we add code to delete the relevant category or item
    func updateModel(at indexPath: IndexPath) {
        // Update our data model
    }
    
}
