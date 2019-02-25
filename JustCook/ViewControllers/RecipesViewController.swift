//
//  RecipesViewController.swift
//  JustCook
//
//  Created by Metricell Developer on 19/01/2019.
//  Copyright © 2019 Faris Zaman. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class RecipesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
  
    let db = Firestore.firestore()
    
    @IBOutlet weak var recipesCollectionView: UICollectionView!
    var recipes = [Recipes]()
    var recipeIcons = [UIImage]()
    var dataSource : FUIFirestoreCollectionViewDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.title = "Recipes"
        
        let shoppingCart = UIButton(type: .custom)
        shoppingCart.setImage(UIImage(named: "shopping-basket"), for: .normal)
        shoppingCart.frame = CGRect(x: self.view.frame.width, y: 0, width: 25, height: 25)
        shoppingCart.addTarget(self, action: #selector(goToShoppingCart), for: .touchUpInside)
        shoppingCart.imageView?.contentMode = .scaleAspectFit
        shoppingCart.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 0)
        let shoppingCartView = UIBarButtonItem(customView: shoppingCart)

        self.navigationItem.setRightBarButton(shoppingCartView, animated: true)
        let query = db.collection("recipes")
        dataSource = recipesCollectionView.bind(toFirestoreQuery: query, populateCell: { (collectionView, indexPath, documentSnapshot) -> UICollectionViewCell in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeCell", for: indexPath) as! RecipesCell
            print("DATA: \(documentSnapshot.data()!)")
            self.recipes.append(Recipes(dictionary: documentSnapshot.data())!)
            cell.recipeTitle.text = self.recipes[indexPath.row].name
            cell.recipeCuisine.text = self.recipes[indexPath.row].cuisineType
            switch self.recipes[indexPath.row].rating {
            case 1:
                cell.recipeRating.image = UIImage.init(named: "onestar.png")
                break
            case 2:
                cell.recipeRating.image = UIImage.init(named: "twostar.png")
                break
            case 3:
                cell.recipeRating.image = UIImage.init(named: "threestar.png")
                break
            case 4:
                cell.recipeRating.image = UIImage.init(named: "fourstar.png")
                break
            case 5:
                cell.recipeRating.image = UIImage.init(named: "fivestar.png")
                break
            default:
                print("Failed to get recipe ratings")
            }
         
            let imageURL = self.recipes[indexPath.row].recipeIcon
            
            if let url = URL(string: imageURL ?? "")
            {
                DispatchQueue.global().async {
                    if let data = try? Data( contentsOf:url)
                    {
                        DispatchQueue.main.async {
                            let recipeImage = UIImage(data: data)
                            cell.recipeImage.image = recipeImage
                        }
                    }
                }
            }
            
            return cell
        })
        
        recipesCollectionView.dataSource = dataSource
        recipesCollectionView.delegate = self
        recipesCollectionView.reloadData()

        self.navigationController?.navigationItem.title = "Recipes"
    }
    
    @objc func goToShoppingCart(){
        let shoppingCartVC = storyboard?.instantiateViewController(withIdentifier: "ShoppingCartViewController") as! ShoppingCartViewController
        self.navigationController?.pushViewController(shoppingCartVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeCell", for: indexPath) as! RecipesCell
        
        let recipeDetails = storyboard?.instantiateViewController(withIdentifier: "RecipeDetailsViewController") as! RecipeDetailsViewController
        present(recipeDetails, animated: true, completion: nil)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! RecipesCell
        let recipeDetails = storyboard?.instantiateViewController(withIdentifier: "RecipeDetailsViewController") as! RecipeDetailsViewController
        recipeDetails.recipeItem = recipes[indexPath.row]
        recipeDetails.recipeImage = cell.recipeImage.image!
        self.navigationController?.pushViewController(recipeDetails, animated: true)
    }


}
