//
//  ViewController.swift
//  Decky
//
//  Created by Armando Torres on 9/28/19.
//  Copyright © 2019 Funkmasters Inc. All rights reserved.
//

import UIKit
import RealmSwift

class CardsViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var cardArray: Results<Card>?
    
    var selectedDeck: Deck?{
        didSet{
            load()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //load()
    }


    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if let card = cardArray?[indexPath.row]
        {
            cell.textLabel?.text = card.name
            cell.accessoryType = card.done ? .checkmark : .none
        }
        else
        {
            cell.textLabel?.text = "No cards added"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardArray?.count ?? 1
    }
    
    //MARK: - Tableview Delegate Methods (U = UPDATE)
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let card = cardArray?[indexPath.row]
        {
            do{
                try realm.write {
                    card.done = !card.done
                }
            } catch{
                print("Error saving done status: \(error)")
            }
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    //MARK: - Add cards (C = CREATE)
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) { //C = CREATE
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add a new card", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add card", style: .default) { (action) in
            
//            let newCard = Card()
//            newCard.name = textField.text!
//            self.save(card: newCard)
            
            if let currentDeck = self.selectedDeck
            {
                do{
                    try self.realm.write {
                        let newCard = Card()
                        newCard.name = textField.text!
                        currentDeck.cards.append(newCard)
                    }
                } catch{
                    print("Error saving new card: \(error)")
                }
            }
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new card"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - Saving and Loading data
    
//    func save(card: Card)
//    {
//        do{
//            try realm.write {
//                realm.add(card)
//            }
//        } catch{
//            print("Error saving card: \(error)")
//        }
//
//        tableView.reloadData()
//    }
    
    func load() // (R = READ)
    {
        
        cardArray = selectedDeck?.cards.sorted(byKeyPath: "name", ascending: true)
        tableView.reloadData()
    }
    
}

extension CardsViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        cardArray = cardArray?.filter("name CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "name", ascending: true)
        tableView.reloadData()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0
        {
            load()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
        
    }
    
    
}

