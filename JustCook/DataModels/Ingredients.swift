//
//  Ingredients.swift
//  JustCook
//
//  Created by Metricell Developer on 10/02/2019.
//  Copyright © 2019 Faris Zaman. All rights reserved.
//

import Foundation

struct Ingredients {
    var name: String!
    var weight: String!
    var price: String!
    var quantity: String!
    var ingredientIcon: String!
    
    init(name: String, weight: String, price: String, quantity: String, ingredientIcon: String){
        self.name = name
        self.weight = weight
        self.price = price
        self.quantity = quantity
        self.ingredientIcon = ingredientIcon
    }
    
    init?(dictionary: [String: Any]?){
        guard let dictionary = dictionary,
            let name = dictionary["name"] as? String,
            let price = dictionary["price"] as? String,
            let quantity = dictionary["quantity"] as? String,
            let weight = dictionary["weight"] as? String,
            let ingredientIcon = dictionary["ingredientIcon"] as? String
        else {
                return nil
        }
        self.init(name: name, weight: weight, price: price, quantity: quantity, ingredientIcon: ingredientIcon)
    }
    
    init?(){
        return nil
    }
}
