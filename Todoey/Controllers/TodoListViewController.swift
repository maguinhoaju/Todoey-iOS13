//
//  ViewController.swift
//  Todoey
//
//  Created by Carlos Magno
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [Item()]
    let dataFieldPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    //var defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFieldPath!)
        
//        itemArray.removeAll()
//        let newItem = Item()
//        newItem.title = "Item 1"
//        itemArray.append(newItem)
//
//        let newItem2 = Item()
//        newItem2.title = "Item 2"
//        itemArray.append(newItem2)
//
//        let newItem3 = Item()
//        newItem3.title = "Item 3"
//        itemArray.append(newItem3)

        //Recuperando informações utilizando NSCoder
        loadItems()
        //recuperando informações utilizando UserDefaults
//        if let items = defaults.array(forKey: Consts.todoListArray) as? [Item] {
//            itemArray = items
//        }
        
    }

    //MARK: - TableView DataSource Methods

    //retorna a quantidade de linhas
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    //retorna as cells contendo o texto de cada item do array
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Consts.todoItemCellId, for: indexPath)
        
        //atribuindo valores à cell
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }

    //MARK: - TableView Delegate Methods
    //Através desse método (do delegate TableView) podemos implementar o check das linhas da tableview
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done

        saveItems()
        //tableView.reloadData()

        //retira a seleção da linha quando clicada
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    //MARK: - Model Manipulation Methods
    
    fileprivate func saveItems() {
        //Persistindo utilizando NSCoder
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(self.itemArray)
            try data.write(to: self.dataFieldPath!)
        } catch {
            print("Error encoding item array - \(error)")
        }
        //refresh na tableView
        self.tableView.reloadData()
    }
    
    fileprivate func loadItems() {
        if let data = try? Data(contentsOf: dataFieldPath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding item array - \(error)")
            }
        }
    }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //o que acontecerá quando o usuário clicar no botão Add Item on UIAlert
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            //Persistindo utilizando NSCoder
            self.saveItems()
            //persistindo utilizando defaults
            //self.defaults.set(self.itemArray, forKey: Consts.todoListArray)
            //refresh na tableView
            //self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
}

