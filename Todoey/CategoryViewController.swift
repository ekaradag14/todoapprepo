//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Erencan Karadağ on 10.05.2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm() // burada ! kullanıyoruz ancak problem değil çünkü realm diyorki eğer ilk defa realm yaratıyorsanız bunu bir do catch e sokun ancak ondan sonra gerek yok
    
    var textField = UITextField()
    var categories: Results<Category>? // Bu bir realm sınıfı
    var cellColor = ""
    var indexPath1: Int = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.separatorStyle = .none
        loadCategories()
      
      
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
         navigationController?.navigationBar.backgroundColor = FlatSkyBlue()
    }
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = self.textField.text!
//            newCategory.color = UIColor.randomFlat().hexValue()
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
    
    override func updateModel(at indexPath: IndexPath) { //superclass içinde anlamsız bir fonksiyon yazdım ve burada gerçek fonksiyonunu verdim
        
//        super.updateModel(at: indexPath) eğer bu kodu yazsaydık superclass içindeki bütün fonkisyonları çağırıp üstüne yaardık ama bunu yapmadan yazdığımız için superclass içindeki fonksiyonun tüm özellikleri çöpe atılacak
        if let categoryForDeletion = self.categories?[indexPath.row]{
            
      
        do {
            try self.realm.write {
                print("Delete Cell")

                self.realm.delete(categoryForDeletion)
                
             
            }
            
        }
        catch {
            print("Error saving done status \(error)")
        }
       }
      }
}
//MARK: - TableView DataSourceMethods

extension CategoryViewController  {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
   
        if categories?.count == 0 {
            return 1
        } else {
            return categories!.count
        }
  
//        return categories?.count ?? 1 // bu nil coalesing operator: bu value nill olabilir, nil olursa 1 bas değere.

    }
    
   
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath) // bu reis superclasstaki cell i alıyor ve onu buraya yapıştırıyor daha sonra biz bu cell in üstüne bir şeyler ekliyoruz
//          cell.delegate = self

               if categories?.count == 0 {
                   cell.textLabel?.text = "No Categories added"
               }  else {
                cell.textLabel?.text = categories?[indexPath.row].name
                cell.backgroundColor = FlatSkyBlue().darken(byPercentage: CGFloat(Float(indexPath.row)/Float(categories!.count)))
                cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
               }
               

//        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added yet"
//
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexPath1 = tableView.indexPathForSelectedRow!.row
        let cell = self.tableView(tableView, cellForRowAt: tableView.indexPathForSelectedRow!)
        tableView.deselectRow(at: indexPath, animated: true)
       let a = cell.backgroundColor?.hexValue()
        cellColor = a!
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
       
       
        destinationVC.selectedCategory = categories?[self.indexPath1]
        destinationVC.parentColor = cellColor
    }
    
}


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
    

    func loadCategories() {
        
        categories = realm.objects(Category.self)
 
    }
}

