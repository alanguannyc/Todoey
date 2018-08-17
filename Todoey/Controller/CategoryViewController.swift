//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Alan on 8/16/18.
//  Copyright © 2018 AlanG. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray : [Category] = []
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Category.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        loadCategory()

    }
    // MARK: - Table view manipulation methods
    func saveCategory() {
        do {
            try context.save()
        } catch  {
            print("Error loading category \(error)")
        }
    }
    
    func loadCategory(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categoryArray = try context.fetch(request)
        } catch  {
            print("Error loading request of loading category \(error)")
        }
        
        tableView.reloadData()
    }
    
    // MARK: - Table view data source methods


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return categoryArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "TodoCategoryCell")
        
        let item = categoryArray[indexPath.row]
        
        cell.textLabel?.text = item.name

        return cell
    }
    
    // MARK: - Table View Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
        
        
    }

    // MARK: - Add new category
    @IBAction func addButtonPressed(_ sender: Any) {
        var textLabel = UITextField()
        
        let alert = UIAlertController(title: "New Category", message: "Add a new category", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (CategoryAlertAction) in
            
            let newCategory = Category(context: self.context)
            
            newCategory.name = textLabel.text
            
            self.categoryArray.append(newCategory)
            
            self.saveCategory()
            
            self.loadCategory()
        }
        
        alert.addAction(action)
        alert.addTextField { (textField) in
            textField.placeholder = "Enter new Category"
            textLabel = textField
            
        }
        
        present(alert, animated: true, completion: nil)
        
        
        
    }
    
    
    
}
