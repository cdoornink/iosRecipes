//
//  GroceryListTableViewController.swift
//  Recipes
//
//  Created by Chris Doornink on 1/7/18.
//  Copyright © 2018 Chris Doornink. All rights reserved.
//

import UIKit

import Firebase
import FirebaseDatabase

class GroceryListTableViewController: UITableViewController, UISearchBarDelegate {

    // MARK: Properties
    @IBOutlet weak var itemAddBar: UISearchBar!
    
    var recipes = [Recipe]()
    var filteredRecipes = [Recipe]()
    var groceryListItems = [GroceryListItem]()
    var itemSuggestions = [String]()
    var filteredItemSuggestions = [String]()
    var organizedGroceryList = [Aisle]()
    var inputTextValue = ""
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "TableSectionHeader", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "TableSectionHeader")
        
        ref = Database.database().reference()
        
        let recipesAPI = RecipesAPI()
        recipesAPI.getRecipes(callback: {(recipes: Array<Recipe>) -> Void in
            self.recipes = recipes
            self.filterRecipes()
        })
        
        recipesAPI.getGroceryListItems(callback: {(groceryListItems: Array<GroceryListItem>) -> Void in
            self.groceryListItems = groceryListItems
            self.organizeItems()
        })
        
        recipesAPI.getItemSuggestions(callback: {(itemSuggestions: Array<String>) -> Void in
            self.itemSuggestions = itemSuggestions
        })

        self.itemAddBar.setImage(UIImage(named: "add-to-cart-gray"), for: .search, state: .normal)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        itemAddBar.endEditing(true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return organizedGroceryList.count + 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.filteredItemSuggestions.count > 0 ? 1 : 0
        } else if organizedGroceryList.count == section - 1 {
            return 1
        } else if organizedGroceryList.count == 0 {
            return 0
        }
        return organizedGroceryList[section - 1].items!.count
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var height: CGFloat = 0
        if section == 0  || organizedGroceryList.count == section - 1 {
            height = 0
        } else if organizedGroceryList.count != 0 && organizedGroceryList[section - 1].items!.count > 0 {
            height = 30
        }
        return height
    }
    
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        print("What the hell")
//        // Here, we use NSFetchedResultsController
//        // And we simply use the section name as title
//        var sectionTitle = ""
//        if organizedGroceryList.count == section {
//            sectionTitle = ""
//        }
//        if organizedGroceryList[section].items!.count > 0 {
//            sectionTitle = organizedGroceryList[section].name.uppercased()
//        }
//
//        // Dequeue with the reuse identifier
//        let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableSectionHeader")
//        let header = cell as! TableSectionHeader
//        header.headerTitle.text = sectionTitle
//
//        return cell
//    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 40
        }
        if organizedGroceryList.count == indexPath.section - 1 {
            if (groceryListItems.count > 0) {
                return 100
            }
            return 0
        }
        return 38
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title = ""
        if section == 0 || organizedGroceryList.count == section - 1 || organizedGroceryList.count == 0 {
            title = ""
        } else if organizedGroceryList[section-1].items!.count > 0 {
            title = organizedGroceryList[section-1].name.uppercased()
        }
        return title
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Top cell - Item Suggestions section
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroceryListItemSuggestionsTableViewCell", for: indexPath) as? GroceryListItemSuggestionsTableViewCell else {
                fatalError("The dequeued cell is not an instance of GroceryListItemSuggestionsTableViewCell.")
            }
            
            cell.suggestionOneLabel.isHidden = true
            cell.suggestionTwoLabel.isHidden = true
            cell.suggestionThreeLabel.isHidden = true
            
            if self.filteredItemSuggestions.count > 0 {
                cell.suggestionOneLabel.setTitle(self.filteredItemSuggestions[0], for: .normal)
                cell.suggestionOneLabel.setTitleColor(Colors.darkBlue, for: .normal)
                cell.suggestionOneLabel.layer.borderColor = Colors.darkBlue.cgColor
                cell.suggestionOneLabel.layer.cornerRadius = 10
                cell.suggestionOneLabel.layer.borderWidth = 2
                cell.suggestionOneLabel.isHidden = false
            }
            
            if self.filteredItemSuggestions.count > 1 {
                cell.suggestionTwoLabel.setTitle(self.filteredItemSuggestions[1], for: .normal)
                cell.suggestionTwoLabel.setTitleColor(Colors.blue, for: .normal)
                cell.suggestionTwoLabel.layer.borderColor = Colors.blue.cgColor
                cell.suggestionTwoLabel.layer.cornerRadius = 10
                cell.suggestionTwoLabel.layer.borderWidth = 2
                cell.suggestionTwoLabel.isHidden = false
            }
            
            if self.filteredItemSuggestions.count > 2 {
                cell.suggestionThreeLabel.setTitle(self.filteredItemSuggestions[2], for: .normal)
                cell.suggestionThreeLabel.setTitleColor(Colors.brightBlue, for: .normal)
                cell.suggestionThreeLabel.titleLabel?.textColor = Colors.white
                cell.suggestionThreeLabel.layer.borderColor = Colors.brightBlue.cgColor
                cell.suggestionThreeLabel.layer.cornerRadius = 10
                cell.suggestionThreeLabel.layer.borderWidth = 2
                cell.suggestionThreeLabel.isHidden = false
            }
            
            cell.groceryListItems = self.groceryListItems
            cell.controller = self
            
            
            return cell
        }
        
        // Bottom cell - Finished Shopping button section
        if organizedGroceryList.count == indexPath.section - 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroceryListCompletedTableViewCell", for: indexPath) as? GroceryListCompletedTableViewCell else {
                fatalError("The dequeued cell is not an instance of GroceryListCompletedTableViewCell.")
            }
            
            cell.recipes = self.recipes
            
            return cell
        }
        
        // All other sections - aisles and grocery list items
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroceryListTableViewCell", for: indexPath) as? GroceryListTableViewCell else {
            fatalError("The dequeued cell is not an instance of GroceryListTableViewCell.")
        }
        
        let item = organizedGroceryList[indexPath.section-1].items![indexPath.row]
        
        cell.name.text = item.name.capitalizeFirstLetter()
        cell.recipes.text = item.recipes?.joined(separator: ", ")
        
        
        
        if item.recipes?.count == 0 {
            cell.nameTopConstraint.constant = 1
        } else {
            cell.nameTopConstraint.constant = -6
        }
        
        // Handles the strikethrough styling if an item is marked as in the (literal) shopping cart
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: cell.name.text!)
        
        if item.inCart == true {
            cell.name.textColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.3)
            cell.recipes.textColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.2)
            attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            attributeString.addAttribute(NSAttributedStringKey.strikethroughColor, value: UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.3), range: NSMakeRange(0, attributeString.length))
        } else {
            cell.name.textColor = UIColor.black
            cell.recipes.textColor = UIColor.gray
            attributeString.removeAttribute(.strikethroughStyle, range: NSMakeRange(0, attributeString.length))
        }
        cell.name.attributedText = attributeString
        
        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            // tableView.deleteRows(at: [indexPath], with: .fade)
            let itemToRemove = organizedGroceryList[indexPath.section - 1].items![indexPath.row]
            
            let api = RecipesAPI()
            api.removeItemFromList(itemToRemove)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    // Override tapping of the item table cell to mark as (inCart / not inCart)
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 || organizedGroceryList.count == indexPath.section - 1 {
            return
        }
        
        let tappedItem = organizedGroceryList[indexPath.section - 1].items![indexPath.row]
        
        tappedItem.inCart = !tappedItem.inCart
        
//        tableView.reloadData()
        let api = RecipesAPI()
        api.updateGroceryListItem(tappedItem)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: Search Bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.inputTextValue = searchText
        self.filterItemSuggestions()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let newItem = searchBar.text {
            let api = RecipesAPI()
            api.addItemToList(newItem, self.groceryListItems, itemSuggestions: self.itemSuggestions)
        }
        searchBar.text = ""
        self.inputTextValue = ""
        self.filterItemSuggestions()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
        self.inputTextValue = ""
        self.filterItemSuggestions()
        
    }
    
    // MARK: Private Methods
    
    /*
     organizeItems - Private Function
     
     Takes the list of GroceryListItems and adds them to the correct aisle sections. Using the
     FredMeyer.aisles list for the names and order of the aisles in the store, and
     FredMeyere.aisleDesignations to match the items name to the aisle it belongs. This list is
     built to take the first match in the list rather than the last, so loops must be exited
     once a match is found.
     */
    private func organizeItems() {
        let allItems = self.groceryListItems
        
        // Initialize empty shopping list organized by aisle
        let organizedGroceryList = FredMeyer.aisles.map { (aisle: String) -> Aisle in
            let name = aisle
            let items = Array<GroceryListItem>()
            
            guard let aisle = Aisle(name: name, items: items) else {
                fatalError("Unable to instanstiate GroceryListItem")
            }
            
            return aisle
        }
        
        allItems.forEach { (item) in
            //loops through all the aisledesignation key value pairs until it finds a match
            var aisle = organizedGroceryList.first(where: { $0.name == "other" })
            for designation in FredMeyer.aisleDesignations {
                if item.name.lowercased().range(of: designation.word.lowercased()) != nil {
                    // finds the right aisle instance to add the item into.
                    aisle = organizedGroceryList.first(where: { $0.name == designation.aisle })
                    break
                }
            }
            aisle!.items! += [item]
        }
        
        organizedGroceryList.forEach { (aisle) in
            aisle.items = aisle.items?.sorted(by: {$0.name.lowercased() < $1.name.lowercased()})
        }
        
        self.organizedGroceryList = organizedGroceryList
        
        self.tableView.reloadData()
    }
    
    private func filterRecipes() {
        self.filteredRecipes = self.recipes.filter({ (recipe: Recipe) -> Bool in
            return recipe.onShoppingList == true
        })
    }
    
    func filterItemSuggestions() {
        let matchingSuggestions = self.itemSuggestions.filter { (itemString) -> Bool in
            return itemString.lowercased().range(of: self.inputTextValue.lowercased()) != nil
        }
        
        self.filteredItemSuggestions = matchingSuggestions.sorted {
            let indexOne = $0.lowercased().range(of: self.inputTextValue.lowercased())?.lowerBound.encodedOffset //There's got to be a better way to do javascript indexOf(String) in Swift than this!!
            let indexTwo = $1.lowercased().range(of: self.inputTextValue.lowercased())?.lowerBound.encodedOffset
            return indexOne! < indexTwo!
        }

        self.tableView.reloadData()
    }

}
