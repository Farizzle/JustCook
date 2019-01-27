//
//  Recipes.swift
//  JustCook
//
//  Created by Metricell Developer on 19/01/2019.
//  Copyright © 2019 Faris Zaman. All rights reserved.
//

import UIKit

enum dietry : String {
    case vegan = "Vegan"
    case diabetic = "Diabetic"
    case ketogenic = "Ketogenic"
    case vegeterian = "Vegeterian"
}

struct Recipes {
    var name: String!
    var cuisineType: String!
    var recipeIcon: String!
    var dietryReqs: dietry!
    var rating: Int?
    
    init(name: String, cuisineType: String, recipeIcon: String, dietryReqs: dietry, rating: Int?) {
        self.name = name
        self.cuisineType = cuisineType
        self.recipeIcon = recipeIcon
        self.dietryReqs = dietryReqs
        self.rating = rating
    }
    
    init?(dictionary: [String: Any]?){
        guard let dictionary = dictionary,
            let name = dictionary["recipeTitle"] as? String,
            let cuisineType = dictionary["recipeCuisine"] as? String,
            let recipeImage = dictionary["recipeImage"] as? String,
            let recipeRating = dictionary["recipeRating"] as? Int
            else{
                return nil
        }

        self.init(name: name, cuisineType: cuisineType, recipeIcon: recipeImage, dietryReqs: dietry.vegan, rating: recipeRating)
    }
    
    init?() {
        return nil
    }
    

}
