//
//  ViewController.swift
//  Todoey
//
//  Created by Carlos Magno
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = ["FInd Mike", "Buy Eggs", "Destroy Demogorfon"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    //MARK: - TableView DataSource Methods

    //retorna a quantidade de linhas
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    //retorna as cells contendo o texto de cada item do array
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Consts.toDoItemCellId, for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }

    //MARK: - TableView Delegate Methods
    //Através desse método (do delegate TableView) podemos implementar o check das linhas da tableview
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        //retira a seleção da linha quando clicada
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //o que acontecerá quando o usuário clicar no botão Add Item on UIAlert
            self.itemArray.append(textField.text!)
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
}

