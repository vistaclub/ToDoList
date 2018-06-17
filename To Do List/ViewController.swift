//
//  ViewController.swift
//  To Do List
//
//  Created by Jason Wong on 2018-06-11.
//  Copyright © 2018 Jason Wong. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    
    // IBOutlet links buttons and text fields from the storyboard to the ViewController
    @IBOutlet weak var importantCheckbox: NSButton!
    @IBOutlet weak var textField: NSTextField!
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var deleteButton: NSButton!
    
    var toDoItems : [ToDoItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        getToDoItems()
    }
    
    func getToDoItems() {
        // Get the todoItems from coredata
        if let context = (NSApplication.shared().delegate as? AppDelegate)?.persistentContainer.viewContext {
            
            do {
                // set them to the class property
                toDoItems = try context.fetch(ToDoItem.fetchRequest())
                print(toDoItems.count) // prints in the console window
            } catch {}
        }
        // update table with contents
        tableView.reloadData()
    }
    
    @IBAction func addClicked(_ sender: Any) {
        if textField.stringValue != "" {
            if let context = (NSApplication.shared().delegate as? AppDelegate)?.persistentContainer.viewContext {
                
                let toDoItem = ToDoItem(context: context)
                
                toDoItem.name = textField.stringValue
                if importantCheckbox.state == 0 {
                    // not important
                    toDoItem.important = false
                } else {
                    // important
                    toDoItem.important = true
                }
                // save the item to core data
                (NSApplication.shared().delegate as? AppDelegate)?.saveAction(nil)
                
                textField.stringValue = ""
                importantCheckbox.state = 0
                
                // refresh list items from core data
                getToDoItems()
            }
        }
    }
    
    //  When the Delete button is pushed
    @IBAction func deleteClicked(_ sender: AnyObject) {
        
        // When the todoItem is selected
        let toDoItem = toDoItems[tableView.selectedRow]
        
        // Get the todoItems from coredata
        if let context = (NSApplication.shared().delegate as? AppDelegate)?.persistentContainer.viewContext {
            context.delete(toDoItem)
            
            // Save core data content
            (NSApplication.shared().delegate as? AppDelegate)?.saveAction(nil)
            
            // refresh the list
            getToDoItems()
            
            // reset button to hidden
            deleteButton.isHidden = true
        }
    }

    // MARK: - TableView Stuff
    func numberOfRows(in tableView: NSTableView) -> Int {
        return toDoItems.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let toDoItem = toDoItems[row]
        
        if tableColumn?.identifier == "importantColumn" {
            // IMPORTANT COLUMN
            if let cell = tableView.make(withIdentifier: "importantCell", owner: self) as? NSTableCellView {
                
                // puts an exclamation icon in the important column if checked
                if toDoItem.important {
                    cell.textField?.stringValue = "❗️"
                } else {
                    cell.textField?.stringValue = ""
                }
                return cell
            }
        } else {
            // TODO COLUMN
            if let cell = tableView.make(withIdentifier: "todoItems", owner: self) as? NSTableCellView {
                cell.textField?.stringValue = toDoItem.name!
                
                return cell
            }
        }
        return nil
    }
    // Tells the delegate if the selection changed and unhide the delete button
    func tableViewSelectionDidChange(_ notification: Notification) {
        deleteButton.isHidden = false
    }
}
