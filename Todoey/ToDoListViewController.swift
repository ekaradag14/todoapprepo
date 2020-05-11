//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData
class ToDoListViewController: UITableViewController {
    
    var textField = UITextField()
    
    var itemArray = [Item]()
    
    var selectedCategory : CategoryData? {
        didSet{
            let parentalPredicate = NSPredicate(format: "parentRelationship.name MATCHES %@", selectedCategory!.name!)
            takeData(usingPredicate: parentalPredicate)
        }
    }
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        //      searchbar 'ın delegate ini searchbara tıklayıp control ile view controller kutucuğuna süsürkleyerek view controller yaptık
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        //        print(dataFilePath)
        //        retrieveData()
        let parentalPredicate = NSPredicate(format: "parentRelationship.name MATCHES %@", selectedCategory!.name!)
        takeData(usingPredicate: parentalPredicate)
        
        //        if let items = defaults.array(forKey: "TodoListArray") as? [Item] { // bunlar user defaultsdan data yüklemek için kullanılıyor
        //            itemArray = items
        //        }
        // Do any additional setup after loading the view.
    }
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            //            let userEntity = NSEntityDescription.entity(forEntityName: "Item", in: self.context)!
            //            let user = NSManagedObject(entity: userEntity, insertInto: self.context)
            //            user.setValue(self.textField.text!, forKey: "title")
            //            user.setValue(false, forKey: "done")
            
            
            let newItem = Item(context: self.context)
            newItem.title = self.textField.text!
            newItem.done = false
            newItem.parentRelationship = self.selectedCategory
            
            self.itemArray.append(newItem)
            self.saveItems()
            //
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
    
    func saveItems() {
        
        do {
            try context.save()
            
        } catch {
            print("Error saving context \(error)")
        }
        self.tableView.reloadData()
    }
    
    func takeData(with request:NSFetchRequest<Item> = Item.fetchRequest(),usingPredicate predicate:NSPredicate? = nil) {
        
        request.predicate = predicate
        do {
            itemArray =  try  context.fetch(request)
        } catch {
            print("Error retrieving context \(error)")
        }
    }
    
    
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
    //    func loadItems() {
    //
    //        if let data = try? Data(contentsOf: dataFilePath!) {
    //            let decoder = PropertyListDecoder()
    //            do {
    //            itemArray = try decoder.decode([Item].self, from: data)
    //
    //            } catch {
    //
    //            }
    //        }
    //
    //    }
    
    
    
}

extension ToDoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let parentalPredicate = NSPredicate(format: "parentRelationship.name MATCHES %@", selectedCategory!.name!)
        let searchPredicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!) // [cd] burada case de diacrateic ' e dikkat etme anlamına getiriyor
        let searchCompoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [parentalPredicate, searchPredicate])
        
        
        request.predicate = searchCompoundPredicate
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        request.sortDescriptors = [sortDescriptor]
        
        takeData(with: request, usingPredicate: searchCompoundPredicate)
        tableView.reloadData()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0  {
            let parentalPredicate = NSPredicate(format: "parentRelationship.name MATCHES %@", selectedCategory!.name!)
            
            
            takeData(usingPredicate: parentalPredicate)
            tableView.reloadData()
            // yani cursor'ı durdur ve ve klavyeyi aşağıya çek çünkü artık first responder yani seçilmiş eleman değilsin
            
            DispatchQueue.main.async { // user interface i yani foreground ı değiştirirken her zaman main thread e geç
                
                searchBar.resignFirstResponder()
                
            }
            
        }
        
    }
    
}

extension ToDoListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none // burası bir TURNERY operator bu operatorın yaptığı şey döndürüp durmak. Burada diyorumki bak bu itemin statusu true mu ? eğer true is .checkmark yap diyorum ha değilse .none yap diyorum A22 ile başlayan kodun yerine geçiyor
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        /*
         context.delete(itemArray[indexPath.row])
         itemArray.remove(at: indexPath.row ) //Burada ikisinin sırası çok önemli eğer önce contextden silmezsek önce context item array içinde olmayan bir sıraya ulaşmaya çalışacak ve index out of range hatası vereek. Buradan context stage area gibi bir şey. Önce orada yapıyoruz değişiklikleri daha sonra push ediyoruz dataları
         
         */
        saveItems()
        
        //          A22
        //        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
        //            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        //        } else {
        //            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        //        }
        
        //        tableView.reloadData() //lecture 259 15:00 Code life cycle dan dolayı burada bir daha çağırmamız gerekiyor
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
}
