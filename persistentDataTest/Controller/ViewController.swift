//
//  ViewController.swift
//  persistentDataTest
//
//  Created by Kiran Kishore on 17/08/19.
//  Copyright © 2019 CDNS. All rights reserved.
//

import UIKit
import CoreData


class ToDoViewController: UITableViewController {
    
    var itemArray = [Item]()
   
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
       fetchData()
       
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
      //  cell.textLabel?.text = itemArray[indexPath.row].title
        
         cell.textLabel?.text = itemArray[indexPath.row].title
        
       
        
      //  cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
        
        if itemArray[indexPath.row].done == true {
           cell.accessoryType = .checkmark
        }else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            
            context.delete(itemArray[indexPath.row])
            itemArray.remove(at: indexPath.row)
            tableView.reloadData()
            saveData()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
      
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveData()
       
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    @IBAction func buttonAdd(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            print(textField.text!)
            
            let newItem = Item(context: self.context)
            
            newItem.title = textField.text!
            newItem.done = false
            self.itemArray.append(newItem)
           
            self.saveData()
            
            print("Array updated")
            self.tableView.reloadData()
        }
        
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
       alert.addAction(action)
       present(alert, animated: true, completion: nil)
    }
    
    //MARK:- Core Data Methods

    func saveData() {
        
        do {
           try context.save()
        }catch {
            print("Error saving context\(error)")
        }
        
        tableView.reloadData()
    }
    
    
    
    func fetchData(){
        
        let request  : NSFetchRequest<Item> = Item.fetchRequest()
        do {
        itemArray = try context.fetch(request)
        } catch
        {
             print("Error fetching data")
        }
        tableView.reloadData()
    }

}


//MARK:- Search Bar Methods

extension ToDoViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        request.predicate = NSPredicate(format: "title CONTAINS %@", searchBar.text!)
        
//        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
//        request.sortDescriptors = [sortDescriptor]
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        do {
            itemArray = try context.fetch(request)
        } catch
        {
            print("Error fetching data")                   //NSHipster NSPredicate
        }
        
        tableView.reloadData()
    }
    
//MARK:- Method to return original list after search
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            
           fetchData()
        }
    }
}

