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

class RecipesViewModel {
    
    var dataSource : FUIFirestoreCollectionViewDataSource!
    var recipes = [Recipes]()
    
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
}
