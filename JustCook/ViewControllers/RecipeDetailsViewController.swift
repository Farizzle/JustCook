//
//  RecipeDetailsViewController.swift
//  JustCook
//
//  Created by Metricell Developer on 27/01/2019.
//  Copyright © 2019 Faris Zaman. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseUI

protocol StoreDelegate {
    func changeSuperMarket(superMarket: String)
}

class RecipeDetailsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, StoreDelegate {
    
    public var recipeItem = Recipes()
    public var recipeImage = UIImage()
    var ingredients = [Ingredients]()
    var userDetails:[NSManagedObject] = []
    let db = Firestore.firestore()
    var dataSource : FUIFirestoreCollectionViewDataSource!
    var supermarket = String()
    var recipePrice : Double = 0
    
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeDescription: UILabel!
    @IBOutlet weak var servingSizeLabel: UILabel!
    @IBOutlet weak var cookTimeImage: UIImageView!
    @IBOutlet weak var cookTimeLabel: UILabel!
    @IBOutlet weak var caloriesImage: UIImageView!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var fridgeImage: UIImageView!
    @IBOutlet weak var fridgeDateLabel: UILabel!
    @IBOutlet weak var ingredientsCollectionView: UICollectionView!
    @IBOutlet weak var addToCartButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userDetails = CoreDataHelper.loadCoreData(entityName: "User");
        let servingSize = (userDetails[userDetails.count-1].value(forKey: "servingSize") as! Int)
        
        self.cookTimeLabel.alpha = 0.0
        self.cookTimeImage.alpha = 0.0
        self.caloriesLabel.alpha = 0.0
        self.caloriesImage.alpha = 0.0
        self.fridgeDateLabel.alpha = 0.0
        self.fridgeImage.alpha = 0.0
        supermarket = "sainsburys"
        
        getRecipeIngredients(recipeName: (recipeItem?.name)!)
        
        let refineButton = UIButton(type: .custom)
        refineButton.setImage(UIImage(named: "shop"), for: .normal)
        refineButton.frame = CGRect(x: self.view.frame.width, y: 0, width: 25, height: 25)
        refineButton.addTarget(self, action: #selector(showSelectionView), for: .touchUpInside)
        refineButton.imageView?.contentMode = .scaleAspectFit
        refineButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 0)
        let refineButtonView = UIBarButtonItem(customView: refineButton)
        
        UINavigationBar.appearance().barTintColor = UIColor(red: 1/255, green: 174/255, blue: 240/255, alpha: 1)
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationItem.title = recipeItem?.name
        self.navigationItem.setRightBarButton(refineButtonView, animated: true)
        self.recipeImageView.image = recipeImage
        self.recipeDescription.text = recipeItem?.description
        if (servingSize == 1){
            servingSizeLabel.text = "When serving for \(servingSize) person"
        } else {
            servingSizeLabel.text = "When serving for \(servingSize) people"
        }
        let calories = Int((recipeItem?.cookTime)!)!
        self.cookTimeLabel.text = "\(calories * servingSize) Mins"
        self.caloriesLabel.text = "\(Int((recipeItem?.calories)!)!) kcal/pp"
        self.fridgeDateLabel.text = recipeItem?.fridgeDate
        
        UIView.animate(withDuration: 0.75, animations: {
            self.cookTimeLabel.alpha = 1.0
            self.cookTimeImage.alpha = 1.0
        }) { (true) in
            UIView.animate(withDuration: 0.75, animations: {
                self.caloriesLabel.alpha = 1.0
                self.caloriesImage.alpha = 1.0
            }, completion: { (true) in
                UIView.animate(withDuration: 0.75, animations: {
                    self.fridgeDateLabel.alpha = 1.0
                    self.fridgeImage.alpha = 1.0
                })

            })
        }
        
        addToCartButton.layer.borderColor = UIColor.white.cgColor
    }
    
    func changeSuperMarket(superMarket: String){
        supermarket = superMarket
        print("New SuperMarket = \(supermarket)")
        getRecipeIngredients(recipeName: recipeItem?.name ?? "")
        calculateRecipePrice()
    }
    
    @objc func showSelectionView(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "StoreSelectView") as! StoreSelectView
        vc.view.backgroundColor = .clear
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    
    func calculateRecipePrice(){
        recipePrice = 0
        for item in ingredients{
            recipePrice += Double(item.price) ?? 0
        }
        addToCartButton.setTitle("Add To Cart - £\(String(format: "%.2f", recipePrice))", for: .normal)
    }
    
    //# Firestore Query
    public func getRecipeIngredients(recipeName: String){
        ingredients.removeAll()
        let query = db.collection("recipes").document(recipeName).collection("ingredients").document(supermarket).collection(getBudgetString())
        dataSource = ingredientsCollectionView.bind(toFirestoreQuery: query, populateCell: { (collectionView, indexPath, documentSnapshot) -> UICollectionViewCell in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IngredientsCell", for: indexPath) as! IngredientsCell
            print("Ingredients: \(documentSnapshot.data()!)")
            self.ingredients.append(Ingredients(dictionary: documentSnapshot.data())!)
            cell.ingredientName.text = self.ingredients[indexPath.row].name
            cell.ingredientPrice.text = "Price: £\(self.ingredients[indexPath.row].price!)"
            cell.ingredientWeight.text = "Weight: \(self.ingredients[indexPath.row].weight!)"
            cell.ingredientQuantity.text = "Qnt: \(self.ingredients[indexPath.row].quantity!)"
            let imageURL = self.ingredients[indexPath.row].ingredientIcon
            UIHelper.downloadImageForCell(imageURL: imageURL!, cellImageView: cell.ingredientImage)
            self.calculateRecipePrice()
            return cell
        })
    }
    
    func getBudgetString() -> String {
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
    
    @IBAction func addToShoppingList(_ sender: Any) {
        recipeItem?.price = recipePrice
        recipeItem?.store = supermarket
        ShoppingCart.recipes.append(recipeItem!)
        print(ShoppingCart.recipes)
    }
    
    //# IngredientsCollectionView Delegates/DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IngredientsCell", for: indexPath) as! IngredientsCell
        
        return cell
    }

}
