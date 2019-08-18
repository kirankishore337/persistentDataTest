//
//  ViewController.swift
//  persistentDataTest
//
//  Created by Kiran Kishore on 17/08/19.
//  Copyright © 2019 CDNS. All rights reserved.
//

import UIKit

class ToDoViewController: UITableViewController {
    
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("Items.plist")
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
       
        print(dataFilePath)
        
      
        
//        let item1 = Item()
//        item1.itemName = "Red"
//        itemArray.append(item1)
//        
//        let item2 = Item()
//        item2.itemName = "Blue"
//        itemArray.append(item2)
//        
//        let item3 = Item()
//        item3.itemName = "Black"
//        itemArray.append(item3)
        
      fetchData()
       
    }

    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row].itemName
        
        
      //  cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
        
        if itemArray[indexPath.row].done == true {
           cell.accessoryType = .checkmark
        }else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
       // itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        if itemArray[indexPath.row].done == false {
            itemArray[indexPath.row].done = true
            
        }else {
            itemArray[indexPath.row].done = false
        }
        
        saveData()
       
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    @IBAction func buttonAdd(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            print(textField.text!)
            
            let newItem = Item()
            newItem.itemName = textField.text!
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

    func saveData() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath)
        }catch {
            print("Error encoding item array, \(error)")
        }
        
        tableView.reloadData()
    }
    
    func fetchData(){
        if let data = try? Data(contentsOf: dataFilePath) {
            let decoder = PropertyListDecoder()
            do{
            itemArray = try decoder.decode([Item].self, from: data)
            }
            catch{
                print("Error decoding tem array")
            }
        }
    }

}

