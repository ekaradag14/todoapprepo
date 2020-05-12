//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Erencan Karadağ on 10.05.2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm() // burada ! kullanıyoruz ancak problem değil çünkü realm diyorki eğer ilk defa realm yaratıyorsanız bunu bir do catch e sokun ancak ondan sonra gerek yok
    
    var textField = UITextField()
    var categories: Results<Category>? // Bu bir realm sınıfı
    
    var indexPath1: Int = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    
        loadCategories()
      
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
    }
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = self.textField.text!
//            self.categoryArray.append(newCategory) bu satırı kullanmıyoruz çünkü categoryArray bir result sınıfı array ve append etmeye gerek yok çünkü auto-append var
            self.saveCategories(category: newCategory)
            
        }
        func configurationTextField(textField: UITextField!) {
            if (textField) != nil {
                self.textField = textField!        //Save reference to the UITextField
                self.textField.placeholder = "Create New Category";
            }
        }
        alert.addAction(action)
        alert.addTextField(configurationHandler: configurationTextField)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))
        present(alert, animated: true, completion: nil)
        
    }
    
}
//MARK: - TableView DataSourceMethods

extension CategoryViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        

        
        if categories?.count == 0 {
            return 1
        } else {
            return categories!.count
        }
  
//        return categories?.count ?? 1 // bu nil coalesing operator: bu value nill olabilir, nil olursa 1 bas değere.

    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
          
        
               if categories?.count == 0 {
                   cell.textLabel?.text = "No Categories added"
               }  else {
                cell.textLabel?.text = categories?[indexPath.row].name
               }
               

//        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added yet"
//
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexPath1 = tableView.indexPathForSelectedRow!.row
       
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
       
        destinationVC.selectedCategory = categories?[self.indexPath1]
               
    }
    
}

//MARK: - TableView Delegate Methods

//MARK: - Data Manipulation Methods

extension CategoryViewController {
    
    
    func saveCategories(category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving context \(error)")
        }
        self.tableView.reloadData()
    }
    
//    func requestData(with request:NSFetchRequest<CategoryData> = CategoryData.fetchRequest()) {
//
//        do {
//            categoryArray =  try  context.fetch(request)
//        } catch {
//            print("Error retrieving context \(error)")
//        }
//    }
    
    func loadCategories() {
        
        categories = realm.objects(Category.self)
 
    }
}

