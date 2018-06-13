//
//  ViewController.swift
//  To Do List
//
//  Created by Jason Wong on 2018-06-11.
//  Copyright © 2018 Jason Wong. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var importantCheckbox: NSButton!
    @IBOutlet weak var textField: NSTextField!
    
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
                print(toDoItems.count)
            } catch {}
        }
        // update
        
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
                (NSApplication.shared().delegate as? AppDelegate)?.saveAction(nil)
                
                textField.stringValue = ""
                importantCheckbox.state = 0
                
                getToDoItems()
            }
        }
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

