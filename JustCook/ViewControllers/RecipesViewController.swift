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
    
    @IBOutlet weak var recipesCollectionView: UICollectionView!
    var dataSource : FUIFirestoreCollectionViewDataSource!
    let recipesViewModel = RecipesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationItem.title = "Recipes"
        
        // Create and setup the shopping cart button & action
        let shoppingCart = UIButton(type: .custom)
        shoppingCart.setImage(UIImage(named: "shopping-basket"), for: .normal)
        shoppingCart.frame = CGRect(x: self.view.frame.width, y: 0, width: 25, height: 25)
        shoppingCart.addTarget(self, action: #selector(goToShoppingCart), for: .touchUpInside)
        shoppingCart.imageView?.contentMode = .scaleAspectFit
        shoppingCart.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 0)
        let shoppingCartView = UIBarButtonItem(customView: shoppingCart)
        self.navigationItem.setRightBarButton(shoppingCartView, animated: true)
        
        // Assign datasource and delegate for collectionView and force reload
        dataSource = recipesViewModel.assignDataSource(collectionView: recipesCollectionView)
        recipesCollectionView.dataSource = dataSource
        recipesCollectionView.delegate = self
        recipesCollectionView.reloadData()

    }
    
    @objc func goToShoppingCart(){
        let shoppingCartVC = storyboard?.instantiateViewController(withIdentifier: "ShoppingCartViewController") as! ShoppingCartViewController
        self.navigationController?.pushViewController(shoppingCartVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipesViewModel.recipes.count
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
        // Allow the image to load for the recipe cell prior to attempting to pass it through to the next VC
        guard let cellImage = cell.recipeImage.image else {return}
        recipeDetails.recipeItem = recipesViewModel.recipes[indexPath.row]
        recipeDetails.recipeImage = cellImage
        self.navigationController?.pushViewController(recipeDetails, animated: true)
    }

}
