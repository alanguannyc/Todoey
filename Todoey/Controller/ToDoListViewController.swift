//
//  ViewController.swift
//  Todoey
//
//  Created by Alan on 8/8/18.
//  Copyright © 2018 AlanG. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
   
    
    
    var defaults = UserDefaults.standard
    var itemArray : [Item] = []
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        loadItems()
       
    }
    
    //MARK - Tableview Datasource Methods
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
        let item = itemArray[indexPath.row]
        
        
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK -
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        print("you're editing")
//    }
    
    //MARK - TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        context.delete(itemArray[indexPath.row])
        
//        itemArray.remove(at: indexPath.row)
        
//        tableView.setEditing(true, animated: true)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.cellForRow(at: indexPath)?.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        tableView.reloadData()
    }
    //MARK -- ADD BUTTON PRESSED
    
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add More", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Finish", style: .default) { (action) in
            
            let newItem = Item(context: self.context)
            
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
            self.itemArray.append(newItem)
            
            self.saveItems()
            
            self.tableView.reloadData()
            
            print("success")
        }
        
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new item"
            textField = alertTextField
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK function save items
    func saveItems() {
        
        do {
            try context.save()
        } catch {
            print("error coding items, \(error)")
        }
    }
    
    //MARK function load items
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), with predicate: NSPredicate? = nil) {
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", (selectedCategory?.name)!)
        
        if let userSetPredicate = predicate {
            request.predicate = NSCompoundPredicate(type: .and, subpredicates: [userSetPredicate, categoryPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
       
        
        do {
             itemArray = try context.fetch(request)
        } catch {
            print("Error fetching requests \(error)")
        }
        
        tableView.reloadData()
    }
}

//MARK: - Search Bar editing
extension ToDoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let searchPredicate = NSPredicate(format: "title contains[cd] %@", searchBar.text!)
//
//        request.predicate = predicate
       
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, with: searchPredicate)
        
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
            
        }
    }
}
