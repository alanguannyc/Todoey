

import UIKit
import CoreData
import RealmSwift
import ChameleonFramework

class ToDoListViewController: SwipeTableViewController {
    
    @IBOutlet weak var barButtonItem: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let realm = try! Realm()
   
    
    var defaults = UserDefaults.standard
    
    var items : Results<Item>?
    
//    var itemArray : [Item] = []
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let font = UIFont.systemFont(ofSize: 40)
        barButtonItem.setTitleTextAttributes([NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): font],
                                             for: .normal)
//        loadItems()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = selectedCategory?.name
        
        guard let navBar = navigationController?.navigationBar else {
            fatalError("navigation controller hasn't loaded")
        }
        
        guard let color = selectedCategory?.color else { fatalError("color doesn't exit")}
        
        updateNavbarColor(with: color)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        guard let originalColor = UIColor(hexString: "2ecc71") else {
            fatalError("No original Color")
        }
        
        updateNavbarColor(with: "2ecc71")
        
        
    }
    //MARK: - Navbar color methods
    func updateNavbarColor(with hexcolor : String) {
        guard let navBar = navigationController?.navigationBar else {
            fatalError("navigation controller hasn't loaded")
        }
        
        guard let navBarColor = UIColor(hexString: hexcolor) else { fatalError("navbar color doesn't exit") }
        
        navBar.barTintColor = navBarColor
        
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
        
        searchBar.barTintColor = navBarColor
    }
    
    //MARK: - Tableview Datasource Methods
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return itemArray.count
        return items?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
//        let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
//        let item = itemArray[indexPath.row]
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = items?[indexPath.row] {
            
            if let color =  HexColor((selectedCategory?.color)!)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat( items!.count)) {
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ? .checkmark : .none
            
            
            
        } else {
            
            cell.textLabel?.text = "No Item added"
        }
        
        return cell
    }
    
    //MARK: -
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        print("you're editing")
//    }
    
    //MARK: - TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let selectedItem = items?[indexPath.row] {
            do{
                try realm.write {
//                    realm.delete(selectedItem)
                    selectedItem.done = !selectedItem.done
                }
            } catch {
                print("Error changing the status \(error)")
            }
        }
        
        
//        context.delete(itemArray[indexPath.row])
        
//        itemArray.remove(at: indexPath.row)
        
//        tableView.setEditing(true, animated: true)
        
//        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        
//        tableView.cellForRow(at: indexPath)?.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
        
//        items[indexPath.row].done = !items[indexPath.row].done
//
//        tableView.cellForRow(at: indexPath)?.accessoryType = items?[indexPath.row].done ? .checkmark : .none

//        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        tableView.reloadData()
    }
    //MARK: -- ADD BUTTON PRESSED
    

    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add More", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Finish", style: .default) { (action) in
            
//            let newItem = Item(context: self.context)
//
//            newItem.title = textField.text!
//            newItem.done = false
//            newItem.parentCategory = self.selectedCategory
//
//            self.itemArray.append(newItem)
            if let currentCategory = self.selectedCategory {
               
                
                do {
                    try self.realm.write {
                        let newItem = Item()
                        
                        newItem.title = textField.text!
                        
                        newItem.dateCreated = Date()
                        
                        currentCategory.items.append(newItem)
                    }
                }
                catch {
                    print("error coding items, \(error)")
                }
                
                
            }
            

            
//            self.save(item: newItem)
            
//            self.save()
            
            self.tableView.reloadData()

        }
        
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new item"
            textField = alertTextField
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: function save items
    func saveItems() {
        
        do {
            try context.save()
        } catch {
            print("error coding items, \(error)")
        }
        
    }

    func save(item: Item) {
        
        do {
            try realm.write {
                realm.add(item)
            }
        }
         catch {
            print("error coding items, \(error)")
        }

    }
    
    //MARK: function load items
//    load with core data functions
//    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), with predicate: NSPredicate? = nil) {
////        let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", (selectedCategory?.name)!)
//
//        if let userSetPredicate = predicate {
//            request.predicate = NSCompoundPredicate(type: .and, subpredicates: [userSetPredicate, categoryPredicate])
//        } else {
//            request.predicate = categoryPredicate
//        }
//
//
//
//        do {
//             itemArray = try context.fetch(request)
//        } catch {
//            print("Error fetching requests \(error)")
//        }
//
//        tableView.reloadData()
//    }
    
    
        func loadItems() {
            items = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
            tableView.reloadData()
        }
    
   override func updateModel(at indexPath: IndexPath) {
    if let selectedItem = self.items?[indexPath.row] {
        do{
            try self.realm.write {
                self.realm.delete(selectedItem)
            }
        } catch {
            print("Error deleting categories \(error)")
        }
        }
    }
}

//MARK: - Search Bar editing
extension ToDoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        items = items?.filter("title contains[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
        
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//        let searchPredicate = NSPredicate(format: "title contains[cd] %@", searchBar.text!)
//
//        request.predicate = predicate

//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItems(with: request, with: searchPredicate)

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
