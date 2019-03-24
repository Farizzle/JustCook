//
//  ShoppingCartViewController.swift
//  JustCook
//
//  Created by Metricell Developer on 24/02/2019.
//  Copyright © 2019 Faris Zaman. All rights reserved.
//

import UIKit

class ShoppingCartViewController: UIViewController, ShoppingCartPrice {
    
    @IBOutlet weak var continuePurchaseButton = UIButton()
    @IBOutlet weak var shoppingCartCollectionView: UICollectionView!
    var shoppingCartViewModel: ShoppingCartViewModel!
    
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
        continuePurchaseButton?.layer.borderColor = UIColor.white.cgColor
    }
    
    func calculateCartPrice(priceString: String) {
        continuePurchaseButton?.setTitle(priceString, for: .normal)
    }
    
 
}
