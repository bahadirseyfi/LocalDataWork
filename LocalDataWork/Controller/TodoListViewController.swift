//
//  ViewController.swift
//  LocalDataWork
//
//  Created by bahadir on 11.11.2020.
//

import UIKit

class TodoListViewController: UITableViewController {

    
    var itemArray = [Item]()
    
    let dataFieldPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFieldPath)
      
        
        navigationItem.title = "Films"
//        if let items = defaults.array(forKey: "FilmListArray") as? [Item] {
//            itemArray = items
//        }
        loadItems()
        
    }
// MARK: - TableView Datasource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       // print("CellForRowAt index path called")
        
       // let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
//        Ternary operator ->
//        value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = item.done ? .checkmark : .none
        
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        
        return cell
    }
    //MARK : TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      //  print(itemArray[indexPath.row])
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
//        if itemArray[indexPath.row].done == false {
//            itemArray[indexPath.row].done = true
//        } else {
//            itemArray[indexPath.row].done = false
//        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    
    
    
    // MARK : - Add New Items
    
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Film", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the add item button on our UIalert
            
            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            
            self.saveItems()
        }
      
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "yeni film oluştur"
            textField = alertTextField
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
//    MARK: - Model Manuplating Methods
    func saveItems(){
        let encoder = PropertyListEncoder()
       
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFieldPath!)
        } catch {
            print("Error encoding item, array\(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems() {
        
        if let data = try? Data(contentsOf: dataFieldPath!){
            let decoder = PropertyListDecoder()
            do{
            itemArray = try decoder.decode([Item].self, from: data)
            }catch{
                print("Error decoding item array, \(error)")
            }
        }
    }
    
}

