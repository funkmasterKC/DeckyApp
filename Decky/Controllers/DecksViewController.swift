//
//  DecksViewController.swift
//  Decky
//
//  Created by Armando Torres on 9/28/19.
//  Copyright © 2019 Funkmasters Inc. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class DecksViewController: SwipeTableViewController {

    let realm = try! Realm()
    
    var deckArray: Results<Deck>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load()
        
        tableView.separatorStyle = .none
    
       
    }

    // MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = deckArray?[indexPath.row].name ?? "No deck added"
        cell.backgroundColor = UIColor(hexString: deckArray?[indexPath.row].color ?? "1D9BF6")
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deckArray?.count ?? 1
    }
  
    
    //MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToCards", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! CardsViewController
        
        if let indexPath  = tableView.indexPathForSelectedRow{
            destinationVC.selectedDeck = deckArray?[indexPath.row]
        }
    }
    
    //MARK: - Add Decks
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add a new deck", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add deck", style: .default) { (action) in
            
            let newDeck = Deck()
            newDeck.name = textField.text!
            newDeck.color = UIColor.randomFlat.hexValue()
            self.save(deck: newDeck)
            
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new deck"
            textField = alertTextField
        }
        
        alert.addAction(action)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Load, save, and delete Decks
    
    func save(deck: Deck)
    {
        do{
            try realm.write {
                realm.add(deck)
            }
        }catch{
            print("Error saving deck: \(error)")
        }
        
        tableView.reloadData()
    }
    
    func load()
    {
        deckArray = realm.objects(Deck.self)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let deckForDeletion = self.deckArray?[indexPath.row]
        {
            do{
                try self.realm.write {
                    self.realm.delete(deckForDeletion)
                }
            } catch {
                print("Error deleting deck: \(error)")
            }
            
        }
    }
}

