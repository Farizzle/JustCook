//
//  ShoppingCartViewController.swift
//  JustCook
//
//  Created by Metricell Developer on 24/02/2019.
//  Copyright © 2019 Faris Zaman. All rights reserved.
//

import UIKit

class ShoppingCartViewController: UIViewController, ShoppingCartPrice {
    
    @IBOutlet var continuePurchaseButton: UIButton!
    @IBOutlet weak var shoppingCartCollectionView: UICollectionView!
    var shoppingCartViewModel: ShoppingCartViewModel!
    @IBOutlet weak var emptyFridge: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Assign navTitle
        self.navigationItem.title = "Shopping Cart"
        
        // Setup viewModel for this viewController
        shoppingCartViewModel = ShoppingCartViewModel.init()
        shoppingCartViewModel.delegate = self
        
        // Assign datasource and delegate for collectionView
        shoppingCartCollectionView.dataSource = shoppingCartViewModel
        shoppingCartCollectionView.delegate = shoppingCartViewModel
        
        // Configure purchase button
        continuePurchaseButton.layer.borderColor = UIColor.white.cgColor
    
    }
    
    // Handle purchaseButton action
    @IBAction func purchaseButton(){
        if (ShoppingCart.recipes.count != 0){
            
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    // Update button with total price of items in cart
    func calculateCartPrice(priceString: String) {
        if (ShoppingCart.recipes.count != 0){
            emptyFridge.alpha = 0
            continuePurchaseButton.setTitle(priceString, for: .normal)
        } else {
            continuePurchaseButton.setTitle("Stock up!", for: .normal)
        }
    }
    
 
}
