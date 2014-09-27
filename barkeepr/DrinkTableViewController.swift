//
//  DrinkTableViewController.swift
//  barkeepr
//
//  Created by Marc Cyr on 9/27/14.
//  Copyright (c) 2014 Barkeepr. All rights reserved.
//

import UIKit

class DrinkTableViewController : UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {
    
    var drinks = [Drink]()
    
    var filteredDrinks = [Drink]()
    
    override func viewDidLoad() {
        // Sample Data for drinkArray
        self.drinks = [Drink(category:"whiskey", name:"Old Fashioned"),
            Drink(category:"gin", name:"Martini"),
            Drink(category:"other", name:"Margarita"),
            Drink(category:"whiskey", name:"Irish Coffee"),
            Drink(category:"gin", name:"Negroni"),
            Drink(category:"bourbon", name:"Mint Julep"),
            Drink(category:"rum", name:"Mai Tai"),
            Drink(category:"other", name:"Pisco Sour"),
            Drink(category:"other", name:"Cosmopolitian"),
            Drink(category:"other", name:"White Russian"),
            Drink(category:"rum", name:"Mojito")]
        
        // Reload the table
        self.tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.searchDisplayController!.searchResultsTableView {
            return self.filteredDrinks.count
        } else {
            return self.drinks.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //ask for a reusable cell from the tableview, the tableview will create a new one if it doesn't have any
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
        
        var drink : Drink
        // Check to see whether the normal table or search results table is being displayed and set the Candy object from the appropriate array
        if tableView == self.searchDisplayController!.searchResultsTableView {
            drink = filteredDrinks[indexPath.row]
        } else {
            drink = drinks[indexPath.row]
        }
        
        // Configure the cell
        cell.textLabel!.text = drink.name
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        self.filteredDrinks = self.drinks.filter({( drink : Drink) -> Bool in
            var categoryMatch = (scope == "All") || (drink.category == scope)
            var stringMatch = drink.name.rangeOfString(searchText)
            return categoryMatch && (stringMatch != nil)
        })
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
        let scopes = self.searchDisplayController!.searchBar.scopeButtonTitles as [String]
        let selectedScope = scopes[self.searchDisplayController!.searchBar.selectedScopeButtonIndex] as String
        self.filterContentForSearchText(searchString, scope: selectedScope)
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController!,
        shouldReloadTableForSearchScope searchOption: Int) -> Bool {
            let scope = self.searchDisplayController!.searchBar.scopeButtonTitles as [String]
            self.filterContentForSearchText(self.searchDisplayController!.searchBar.text, scope: scope[searchOption])
            return true
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("drinkDetail", sender: tableView)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "drinkDetail" {
            let drinkDetailViewController = segue.destinationViewController as UIViewController
            if sender as UITableView == self.searchDisplayController!.searchResultsTableView {
                let indexPath = self.searchDisplayController!.searchResultsTableView.indexPathForSelectedRow()!
                let destinationTitle = self.filteredDrinks[indexPath.row].name
                drinkDetailViewController.title = destinationTitle
            } else {
                let indexPath = self.tableView.indexPathForSelectedRow()!
                let destinationTitle = self.drinks[indexPath.row].name
                drinkDetailViewController.title = destinationTitle
            }
        }
    }
}
