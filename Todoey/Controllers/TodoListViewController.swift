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
    //Obtém o contexto através da UIApplication (esta aplicação) - shared (objetos singleton compartilhados - aplicação corrente na forma de objeto)
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //didSet especifica o que deve ser feito quando a variável tiver for setada. Nesse caso ela está sendo setada na CategoryViewController
    var category: Category? {
        didSet {
            loadItems()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        //Com a passagem de parâmetro Category, esta linha não é mais necessária aqui
        //loadItems()
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
    //Item.fetchRequest() é utilizado caso não seja passado parâmetro
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        //filtro para retornar somente os items relacionados à category selecionada
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", category!.name!)
        //Caso o predicate tenha sido informado, temos que filtrar tanto pelo categoryPredicate quanto pelo predicate
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context - \(error)")
        }
        
        tableView.reloadData()
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
            newItem.parentCategory = self.category
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

//MARK: - SearchBar Delegate

extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        //criando o filtro
        //[cd] - significa CASE and DIACRITIC insensitive
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)

        //criando o sort
        //sortDescriptor recebe um array. Sendo assim, podemos criar vários sorts
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            //DispatchQueue gerencia a atribuição de objetos a diferentes threads.
            //Ou seja, o código abaixo está pedindo para que a linha seja executada na fila principal de forma assíncrona
            DispatchQueue.main.async {
                //retorna o estado inicial da searchBar
                searchBar.resignFirstResponder()
            }
        }
    }
}
