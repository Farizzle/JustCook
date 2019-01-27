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
    var dataSource : FUIFirestoreCollectionViewDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let query = db.collection("recipes")

        dataSource = recipesCollectionView.bind(toFirestoreQuery: query, populateCell: { (collectionView, indexPath, documentSnapshot) -> UICollectionViewCell in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeCell", for: indexPath) as! RecipesCell
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
                            cell.recipeImage.image = UIImage( data:data)
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
        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeCell", for: indexPath) as! RecipesCell
        
        let recipeDetails = storyboard?.instantiateViewController(withIdentifier: "RecipeDetailsViewController") as! RecipeDetailsViewController
        recipeDetails.navTitle = cell.recipeTitle.text ?? ""
        present(recipeDetails, animated: true, completion: nil)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeCell", for: indexPath) as! RecipesCell
        
        let recipeDetails = storyboard?.instantiateViewController(withIdentifier: "RecipeDetailsViewController") as! RecipeDetailsViewController
        recipeDetails.navTitle = recipes[indexPath.row].name
        self.navigationController?.pushViewController(recipeDetails, animated: true)
    }


}