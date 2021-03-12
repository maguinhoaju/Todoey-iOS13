//
//  ViewController.swift
//  Todoey
//
//  Created by Carlos Magno
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    //obtem o contexto através da UIApplication (esta aplicação) - shared (objetos singleton compartilhados - aplicação corrente na forma de objeto)
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    //var defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
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

        //retira a seleção da linha quando clicada
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    //MARK: - Model Manipulation Methods
    
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving context - \(error)")
        }
        //refresh na tableView
        self.tableView.reloadData()
    }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //o que acontecerá quando o usuário clicar no botão Add Item on UIAlert
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            self.itemArray.append(newItem)
            self.saveItems()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
}

