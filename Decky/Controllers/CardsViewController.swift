//
//  ViewController.swift
//  Decky
//
//  Created by Armando Torres on 9/28/19.
//  Copyright © 2019 Funkmasters Inc. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CardsViewController: SwipeTableViewController {
    
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
        tableView.separatorStyle = .none
    }


    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let card = cardArray?[indexPath.row]
        {
            cell.textLabel?.text = card.name
            cell.accessoryType = card.done ? .checkmark : .none
            
            if let color = UIColor(hexString: (cardArray?[indexPath.row].hexCode)!)
            {
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            else
            {
                cell.textLabel?.text = "No cards added"
            }
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
        
        let addMonster = UIAlertAction(title: "Add Monster", style: .default) { (action) in
            let newCard = Card()
            self.addMonsterCard(textfield: textField, addNewCard: newCard)
            self.addProperties(textField: textField, addNewCard: newCard)
        }
        
        let addMagic = UIAlertAction(title: "Add Magic", style: .default) { (action) in
            let newCard = Card()
            self.addMagicCard(textField: textField, addNewCard: newCard)
            self.addProperties(textField: textField, addNewCard: newCard)
        }
        
        let addTrap = UIAlertAction(title: "Add Trap", style: .default) { (action) in
            let newCard = Card()
            self.addTrapCard(textfield: textField, addNewCard: newCard)
            self.addProperties(textField: textField, addNewCard: newCard)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new card"
            textField = alertTextField
        }

        alert.addAction(addMonster)
        alert.addAction(addMagic)
        alert.addAction(addTrap)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    func addProperties(textField: UITextField, addNewCard: Card)
    {
        if let currentDeck = self.selectedDeck
        {
            do{
                try self.realm.write {
                    let newCard = addNewCard
                    newCard.name = textField.text!
                    currentDeck.cards.append(newCard)
                }
            } catch{
                print("Error saving new card: \(error)")
            }
        }
        self.tableView.reloadData()
    }
    
    func addMonsterCard(textfield: UITextField, addNewCard: Card)
    {
        addNewCard.monster = true
        addNewCard.hexCode = UIColor.flatYellow.hexValue()
    }
    
    func addMagicCard(textField: UITextField, addNewCard: Card)
    {
        addNewCard.magic = true
        addNewCard.hexCode = UIColor.flatSkyBlue.hexValue()
    }
    
    func addTrapCard(textfield: UITextField, addNewCard: Card)
    {
        addNewCard.trap = true
        addNewCard.hexCode = UIColor.flatMagenta.hexValue()
    }
    
    
    //MARK: - Loading data
    
    func load() // (R = READ)
    {
        
        cardArray = selectedDeck?.cards.sorted(byKeyPath: "name", ascending: true)
        tableView.reloadData()
    }
    
    //MARK: - Deleting data
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let cardForDeletion = self.cardArray?[indexPath.row]
        {
            do{
                try self.realm.write {
                    self.realm.delete(cardForDeletion)
                }
            } catch {
                print("Error deleting card: \(error)")
            }
            
        }
    }
    
}

//MARK: - Search Bar Methods

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

