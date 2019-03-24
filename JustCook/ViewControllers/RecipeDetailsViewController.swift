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

//protocol StoreDelegate {
//    func changeSuperMarket(superMarket: String)
//}

class RecipeDetailsViewController: UIViewController, StoreDelegate, RecipePrices {
    
    public var recipeImage = UIImage()
    var recipeDetailsViewModel: RecipeDetailsViewModel!
    var recipeItem = Recipes()
    
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
        
        // Assign navTitle
        self.navigationItem.title = recipeItem?.name
        
        // Create and setup the store selector button
        let refineButton = UIButton(type: .custom)
        refineButton.setImage(UIImage(named: "shop"), for: .normal)
        refineButton.frame = CGRect(x: self.view.frame.width, y: 0, width: 25, height: 25)
        refineButton.addTarget(self, action: #selector(showSelectionView), for: .touchUpInside)
        refineButton.imageView?.contentMode = .scaleAspectFit
        refineButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 0)
        let refineButtonView = UIBarButtonItem(customView: refineButton)
        self.navigationItem.setRightBarButton(refineButtonView, animated: true)

        // Setup viewModel with this viewController
        recipeDetailsViewModel = RecipeDetailsViewModel.init(recipeDetailsVC: self)
        
        // Assign datasource and delegate for collectionView and force reload
        guard let recipeName = recipeItem?.name else{return}
        ingredientsCollectionView.dataSource = recipeDetailsViewModel.assignDataSource(collectionView: ingredientsCollectionView, withRecipe: recipeName)
        ingredientsCollectionView.delegate = recipeDetailsViewModel
        ingredientsCollectionView.reloadData()
        
        // Assign delegates for PriceCalculation & Store select change
        recipeDetailsViewModel.delegate = self
        
        // Setup UI & Animations
        setupHoldingUI()
    }
    
    // Once VM has loaded data, passes the price value to VC
    func totalPriceCalculated(calculatedPrice: String){
        addToCartButton.setTitle(calculatedPrice, for: .normal)
    }
    
    // StoreDelegate - Re-queries the database with new supermarket
    func changeSuperMarket(superMarket: String) {
        guard let recipeName = recipeItem?.name else{return}
        recipeDetailsViewModel.supermarket = superMarket
        ingredientsCollectionView.dataSource = recipeDetailsViewModel.assignDataSource(collectionView: ingredientsCollectionView, withRecipe: recipeName)
    }
    
    // Adds this recipeItem to the shoppingCart
    @IBAction func addToShoppingList(_ sender: Any) {
        recipeItem?.price = recipeDetailsViewModel.recipePrice
        recipeItem?.store = recipeDetailsViewModel.supermarket
        ShoppingCart.recipes.append(recipeItem!)
        print(ShoppingCart.recipes)
    }
    
    // Launches view to change super market
    @objc func showSelectionView(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "StoreSelectView") as! StoreSelectView
        vc.view.backgroundColor = .clear
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
   
    // Handles fading animation & UILabel's content
    func setupHoldingUI(){
        self.cookTimeLabel.alpha = 0.0
        self.cookTimeImage.alpha = 0.0
        self.caloriesLabel.alpha = 0.0
        self.caloriesImage.alpha = 0.0
        self.fridgeDateLabel.alpha = 0.0
        self.fridgeImage.alpha = 0.0
        
        self.recipeImageView.image = recipeImage
        self.recipeDescription.text = recipeItem?.description
        if (recipeDetailsViewModel.servingSize == 1){
            servingSizeLabel.text = "When serving for \(recipeDetailsViewModel.servingSize) person"
        } else {
            servingSizeLabel.text = "When serving for \(recipeDetailsViewModel.servingSize) people"
        }
        let cookTime = Int((recipeItem?.cookTime)!)!
        self.cookTimeLabel.text = "\(cookTime * recipeDetailsViewModel.servingSize) Mins"
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
}
