//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
class ToDoListViewController: UITableViewController {
    
    var textField = UITextField()
    let realm = try! Realm()
    var todoItems: Results<Item>?
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        
        //        print(dataFilePath)
        //        retrieveData()
        //        let parentalPredicate = NSPredicate(format: "parentRelationship.name MATCHES %@", selectedCategory!.name!)
        //        takeData(usingPredicate: parentalPredicate)
        
        //        if let items = defaults.array(forKey: "TodoListArray") as? [Item] { // bunlar user defaultsdan data yüklemek için kullanılıyor
        //            itemArray = items
        //        }
        // Do any additional setup after loading the view.
    }
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = self.textField.text!
//                        newItem.dateAsTimeStamp = Date()  timestamp sorting in ikinci bölümü
                        currentCategory.items.append(newItem)
                        
                    }
                } catch {
                    print("Error saving context \(error)")
                }
            }
            
            
            self.tableView.reloadData()
            
        }
        
        func configurationTextField(textField: UITextField!) {
            if (textField) != nil {
                self.textField = textField!        //Save reference to the UITextField
                self.textField.placeholder = "Create New Item";
            }
        }
        alert.addAction(action)
        alert.addTextField(configurationHandler: configurationTextField)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))
        present(alert, animated: true, completion: nil)
        
    }
    
  
    //
    //    func takeData(with request:NSFetchRequest<Item> = Item.fetchRequest(),usingPredicate predicate:NSPredicate? = nil) {
    //
    //        request.predicate = predicate
    //        do {
    //            itemArray =  try  context.fetch(request)
    //        } catch {
    //            print("Error retrieving context \(error)")
    //        }
    //    }
    ////
    //
    // MARK: - Internal Resource Database Fetch
    
    
    //        let request : NSFetchRequest<Item> = Item.fetchRequest() // Output'un ne type da olduğunu belirtmemiz gerekiyor burada
    
    //    // MARK: - External Resource Database Fetch
    //    func retrieveData() {
    //
    //        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    //
    //        let managedContext = appDelegate.persistentContainer.viewContext
    //
    //        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
    //
    //        //        fetchRequest.fetchLimit = 1
    //        //        fetchRequest.predicate = NSPredicate(format: "username = %@", "Ankur")
    //        //        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "email", ascending: false)]
    //        //
    //        do {
    //            let result = try managedContext.fetch(fetchRequest)
    //            itemArray = result as! [Item]
    //            print(itemArray)
    //            //                for data in result as! [Item] {
    //            //                    itemArray = result as! [Item]
    //            //                    print(itemArray)
    //            //                }
    //
    //        } catch {
    //
    //            print("Failed")
    //        }
    //    }
    //
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
             tableView.reloadData()
    }
    
    
    
}

extension ToDoListViewController : UISearchBarDelegate {
    

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "date", ascending: true)

    tableView.reloadData()
        
 
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
       
        if searchBar.text?.count == 0  {
           
            loadItems()
            
            DispatchQueue.main.async { // user interface i yani foreground ı değiştirirken her zaman main thread e geç

                searchBar.resignFirstResponder()

            }
}
        else {
              todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
            tableView.reloadData()
        }

    }

}

extension ToDoListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
          if todoItems?.count == 0 {
               return 1
           } else {
               return todoItems!.count
           }
                 

//        return todoItems?.count ?? 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if todoItems?.count == 0 {
                    cell.textLabel?.text = "No items added yet."
                  }  else {
            let item = todoItems?[indexPath.row]
            cell.textLabel?.text =  item?.title
            cell.accessoryType = item?.done ?? false ? .checkmark : .none
                  }
        
  
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        do {
            try self.realm.write {
                if  let newItem = todoItems?[indexPath.row] {
//                    realm.delete(newItem) Bu da siliyor
                    newItem.done = !newItem.done
                    tableView.reloadData()
                }
                
            }
        } catch {
            print("Error saving done status \(error)")
        }
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}
