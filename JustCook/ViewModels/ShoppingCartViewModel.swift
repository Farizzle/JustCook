//
//  ShoppingCartViewModel.swift
//  JustCook
//
//  Created by Metricell Developer on 24/03/2019.
//  Copyright © 2019 Faris Zaman. All rights reserved.
//

import Foundation
import UIKit

protocol ShoppingCartPrice {
    func calculateCartPrice(priceString: String)
}

class ShoppingCartViewModel: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var cartPrice: Double = 0
    var delegate: ShoppingCartPrice?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        calculateCartPrice()
        return ShoppingCart.recipes.count
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShoppingCartCell", for: indexPath) as! ShoppingCartCell
        cell.recipeName.text = ShoppingCart.recipes[indexPath.row].name
        UIHelper.downloadImageForCell(imageURL: ShoppingCart.recipes[indexPath.row].recipeIcon, cellImageView: cell.recipeImage)
        UIView.animate(withDuration: 0.75, animations: {
            cell.caloriesImage.alpha = 1.0
            cell.recipeCalories.alpha = 1.0
        }) { (true) in
            UIView.animate(withDuration: 0.75, animations: {
                cell.expImage.alpha = 1.0
                cell.expDate.alpha = 1.0
            })
        }
        cell.recipePrice.text = "£\(String(format: "%.2f", ShoppingCart.recipes[indexPath.row].price ?? 0))"
        cell.recipeCalories.text = "\(Int(ShoppingCart.recipes[indexPath.row].calories) ?? 0)" + " kcal/pp"
        cell.expDate.text = ShoppingCart.recipes[indexPath.row].fridgeDate
        let finalFrame = cell.recipeImage.frame
        cell.recipeImage.frame = CGRect(x: cell.recipeImage.frame.origin.x-150, y: cell.recipeImage.frame.origin.y, width: cell.recipeImage.frame.size.width, height: cell.recipeImage.frame.size.height)
        UIView.animate(withDuration: 1.0, animations: {
            cell.recipeImage.frame = finalFrame
        })
        switch ShoppingCart.recipes[indexPath.row].store {
        case "asda":
            cell.recipeSuperMarket.image = UIImage(named: "asda")
            break
        case "tesco":
            cell.recipeSuperMarket.image = UIImage(named: "tesco")
            break
        case "sainsburys":
            cell.recipeSuperMarket.image = UIImage(named: "sainsburys")
            break
        case "aldi":
            cell.recipeSuperMarket.image = UIImage(named: "aldi")
            break
        case "waitrose":
            cell.recipeSuperMarket.image = UIImage(named: "waitrose")
            break
        default:
            break
        }
        cell.recipeImage.layer.cornerRadius = 10
        cell.recipeImage.layer.masksToBounds = true
        return cell
    }
    
    func calculateCartPrice(){
        cartPrice = 0
        for item in ShoppingCart.recipes{
            cartPrice += Double(item.price ?? 0)
        }
        let cartPriceString = "Purchase - £\(String(format: "%.2f", cartPrice))"
        if let delegate = self.delegate {
            delegate.calculateCartPrice(priceString: cartPriceString)
        }
    }

}
