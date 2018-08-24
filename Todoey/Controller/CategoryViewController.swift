//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Alan on 8/16/18.
//  Copyright © 2018 AlanG. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
import ChameleonFramework


class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categories : Results<Category>?
    
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
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
            
        } catch  {
            print("Error loading category \(error)")
        }
    }
    
    //load category with core data function
//    func loadCategory(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
//
//
//        do {
//            categories = try context.fetch(request)
//        } catch  {
//            print("Error loading request of loading category \(error)")
//        }
//
//        tableView.reloadData()
//    }
    
    func loadCategory() {
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    // MARK: - Delete by swipe
    override func updateModel(at indexPath: IndexPath) {
        if let selectedCategory = self.categories?[indexPath.row] {
            do{
                try self.realm.write {
                    self.realm.delete(selectedCategory)
                }
            } catch {
                print("Error deleting categories \(error)")
            }
            
           
    }
    }
    
    
    // MARK: - Table view data source methods


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return categories?.count ?? 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        
        let item = categories?[indexPath.row]
        
        cell.textLabel?.text = item?.name ?? "No Categories yet"
        
        cell.backgroundColor = HexColor((item?.color) ?? "2ecc71")
        
        cell.textLabel?.textColor = ContrastColorOf(HexColor((item?.color)!)!, returnFlat: true)
        
        return cell
        
    }
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cell = UITableViewCell(style: .default, reuseIdentifier: "TodoCategoryCell")
//
//        let item = categories?[indexPath.row]
//
//        cell.textLabel?.text = item?.name ?? "No Categories yet"
//
//        return cell
//    }
    
    // MARK: - Table View Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
            
        }
        
        
    }

    // MARK: - Add new category
    @IBAction func addButtonPressed(_ sender: Any) {
        var textLabel = UITextField()
        
        let alert = UIAlertController(title: "New Category", message: "Add a new category", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (CategoryAlertAction) in
            
//            let newCategory = Category(context: self.context)
            
            let newCategory = Category()
            
            newCategory.name = textLabel.text!
            
            newCategory.color = UIColor.randomFlat.hexValue()
            
//            self.categoryArray.append(newCategory)
            
            self.save(category: newCategory)
            
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

    //MARK: - Swipe cell delegate
//extension CategoryViewController : SwipeTableViewCellDelegate {
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
//        guard orientation == .right else { return nil }
//        
//        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
//            // handle action by updating model with deletion
//            print("Item Deleted")
//            if let selectedCategory = self.categories?[indexPath.row] {
//                do{
//                    try self.realm.write {
//                        self.realm.delete(selectedCategory)
//                    }
//                } catch {
//                    print("Error deleting categories \(error)")
//                }
//                
//                tableView.reloadData()
//            }
//            
//        }
//        
//        // customize the action appearance
//        deleteAction.image = UIImage(named: "Trash-Icon")
//        
//        return [deleteAction]
//    }
//    
//    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
//        var options = SwipeOptions()
//        options.expansionStyle = .destructive
//        options.transitionStyle = .border
//        return options
//    }
//}

