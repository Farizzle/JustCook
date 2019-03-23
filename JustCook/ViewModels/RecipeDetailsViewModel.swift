//
//  RecipeDetailsViewModel.swift
//  JustCook
//
//  Created by Metricell Developer on 23/03/2019.
//  Copyright © 2019 Faris Zaman. All rights reserved.
//

import Foundation
import CoreData
import Firebase
import FirebaseUI

protocol StoreDelegate {
    func changeSuperMarket(superMarket: String)
}

protocol RecipePrices {
    func totalPriceCalculated(calculatedPrice: String)
}

class RecipeDetailsViewModel: NSObject, UICollectionViewDelegate {
    
    var userDetails:[NSManagedObject] = []
    var servingSize = Int()
    var viewController : RecipeDetailsViewController!
    var ingredients = [Ingredients]()
    var dataSource : FUIFirestoreCollectionViewDataSource!
    var supermarket = String()
    var totalPrice = String()
    var recipePrice : Double = 0
    var delegate : RecipePrices?

    init(recipeDetailsVC: RecipeDetailsViewController) {
        viewController = recipeDetailsVC
        userDetails = CoreDataHelper.loadCoreData(entityName: "User")
        servingSize = (userDetails[userDetails.count-1].value(forKey: "servingSize") as! Int)
        supermarket = "sainsburys"
    }
    
    func assignDataSource(collectionView: UICollectionView, withRecipe: String) -> FUIFirestoreCollectionViewDataSource{
        ingredients.removeAll()
        let query = AppDelegate.database.collection("recipes").document(withRecipe).collection("ingredients").document(supermarket).collection(getBudgetString())
        dataSource = collectionView.bind(toFirestoreQuery: query, populateCell: { (collectionView, indexPath, documentSnapshot) -> UICollectionViewCell in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IngredientsCell", for: indexPath) as! IngredientsCell
            print("Ingredients: \(documentSnapshot.data()!)")
            self.ingredients.append(Ingredients(dictionary: documentSnapshot.data())!)
            cell.ingredientName.text = self.ingredients[indexPath.row].name
            cell.ingredientPrice.text = "Price: £\(self.ingredients[indexPath.row].price!)"
            cell.ingredientWeight.text = "Weight: \(self.ingredients[indexPath.row].weight!)"
            cell.ingredientQuantity.text = "Qnt: \(self.ingredients[indexPath.row].quantity!)"
            let imageURL = self.ingredients[indexPath.row].ingredientIcon
            UIHelper.downloadImageForCell(imageURL: imageURL!, cellImageView: cell.ingredientImage)
            if let delegate = self.delegate {
                delegate.totalPriceCalculated(calculatedPrice: self.calculateRecipePrice())
            }
            return cell
        })
        return dataSource
    }

    func getBudgetString() -> String{
        let budgetInt = (userDetails[userDetails.count-1].value(forKey: "budget") as! Int)
        var budgetString = String()
        switch budgetInt {
        case 1:
            budgetString = "lowtier"
            break
        case 2:
            budgetString = "midtier"
            break
        case 3:
            budgetString = "hightier"
            break
        default:
            return ""
        }
        return budgetString
    }
    
    func calculateRecipePrice() -> String{
        recipePrice = 0
        for item in ingredients{
            recipePrice += Double(item.price) ?? 0
        }
        return "Add To Cart - £\(String(format: "%.2f", recipePrice))"
    }
    
    func changeSuperMarket(superMarket: String){
        print("New SuperMarket = \(supermarket)")
        if let delegate = self.delegate {
            delegate.totalPriceCalculated(calculatedPrice: self.calculateRecipePrice())
        }
    }
    
    func reloadData(){
        
    }
    
    // IngredientsCollectionView Delegates/DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    private func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IngredientsCell", for: indexPath) as! IngredientsCell
        return cell
    }
}
