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

class RecipesViewController: UIViewController {
    
    @IBOutlet weak var recipesCollectionView: UICollectionView!
    var dataSource : FUIFirestoreCollectionViewDataSource!
    var recipesViewModel: RecipesViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Assign navTitle
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
        
        // Setup viewModel with this viewController
        recipesViewModel = RecipesViewModel.init(recipesVC: self)
        
        // Assign datasource and delegate for collectionView and force reload
        dataSource = recipesViewModel.assignDataSource(collectionView: recipesCollectionView)
        recipesCollectionView.dataSource = dataSource
        recipesCollectionView.delegate = recipesViewModel
        recipesCollectionView.reloadData()

    }
    
    @objc func goToShoppingCart(){
        let shoppingCartVC = storyboard?.instantiateViewController(withIdentifier: "ShoppingCartViewController") as! ShoppingCartViewController
        self.navigationController?.pushViewController(shoppingCartVC, animated: true)
    }
    
}
