//
//  RecipesViewModel.swift
//  JustCook
//
//  Created by Metricell Developer on 23/03/2019.
//  Copyright © 2019 Faris Zaman. All rights reserved.
//

import Foundation
import Firebase
import FirebaseUI

class RecipesViewModel: NSObject, UICollectionViewDelegate {
    
    var dataSource : FUIFirestoreCollectionViewDataSource!
    var recipes = [Recipes]()
    var viewController : UIViewController!
    
    init(recipesVC: RecipesViewController) {
        viewController = recipesVC
    }
    
    func assignDataSource(collectionView: UICollectionView) -> FUIFirestoreCollectionViewDataSource {
        let query = AppDelegate.database.collection("recipes")
        dataSource = collectionView.bind(toFirestoreQuery: query, populateCell: { (collectionView, indexPath, documentSnapshot) -> UICollectionViewCell in
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
        
        return dataSource
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipes.count
    }
    
    private func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeCell", for: indexPath) as! RecipesCell
        let recipeDetails = viewController.storyboard?.instantiateViewController(withIdentifier: "RecipeDetailsViewController") as! RecipeDetailsViewController
        viewController.present(recipeDetails, animated: true, completion: nil)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! RecipesCell
        let recipeDetails = viewController.storyboard?.instantiateViewController(withIdentifier: "RecipeDetailsViewController") as! RecipeDetailsViewController
        // Allow the image to load for the recipe cell prior to attempting to pass it through to the next VC
        guard let cellImage = cell.recipeImage.image else {return}
        recipeDetails.recipeItem = recipes[indexPath.row]
        recipeDetails.recipeImage = cellImage
        viewController.navigationController?.pushViewController(recipeDetails, animated: true)
    }

}
