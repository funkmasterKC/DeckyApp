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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        load()
    }


    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = cardArray?[indexPath.row].name ?? "No cards added"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardArray?.count ?? 1
    }
    
    //MARK: - Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    //MARK: - Add cards
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) { //C = CREATE
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add a new card", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add card", style: .default) { (action) in
            
            let newCard = Card()
            newCard.name = textField.text!
            self.save(card: newCard)
            
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new card"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - Saving and Loading data
    
    func save(card: Card)
    {
        do{
            try realm.write {
                realm.add(card)
            }
        } catch{
            print("Error saving card: \(error)")
        }
        
        tableView.reloadData()
    }
    
    func load()
    {
        cardArray = realm.objects(Card.self)
        tableView.reloadData()
    }
    
}

