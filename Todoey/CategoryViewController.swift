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
    var categoryArray = [CategoryData]()
    var indexPath1: Int = 0
  
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
            self.categoryArray.append(newCategory)
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
        return categoryArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let cat = categoryArray[indexPath.row]
        cell.textLabel?.text = cat.name
   
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexPath1 = tableView.indexPathForSelectedRow!.row
       
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        print(indexPath1)
        destinationVC.selectedCategory = categoryArray[self.indexPath1]
               
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
    
    func requestData(with request:NSFetchRequest<CategoryData> = CategoryData.fetchRequest()) {
        
        do {
            categoryArray =  try  context.fetch(request)
        } catch {
            print("Error retrieving context \(error)")
        }
    }
    
    func loadCategories() {
        
//        let request : NSFetchRequest<CategoryData> = CategoryData.fetchRequest()
//        requestData(with: request)
//        
    }
}

