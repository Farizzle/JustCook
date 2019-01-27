//
//  RecipeDetailsViewController.swift
//  JustCook
//
//  Created by Metricell Developer on 27/01/2019.
//  Copyright © 2019 Faris Zaman. All rights reserved.
//

import UIKit
import CoreData

class RecipeDetailsViewController: UIViewController {
    
    public var recipeItem = Recipes()
    public var recipeImage = UIImage()
    var userDetails:[NSManagedObject] = []

    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeDescription: UILabel!
    @IBOutlet weak var servingSizeLabel: UILabel!
    @IBOutlet weak var cookTimeImage: UIImageView!
    @IBOutlet weak var cookTimeLabel: UILabel!
    @IBOutlet weak var caloriesImage: UIImageView!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var fridgeImage: UIImageView!
    @IBOutlet weak var fridgeDateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userDetails = CoreDataHelper.loadCoreData(entityName: "User");
        let servingSize = (userDetails[userDetails.count-1].value(forKey: "servingSize") as! Int)

        self.cookTimeLabel.alpha = 0.0
        self.cookTimeImage.alpha = 0.0
        self.caloriesLabel.alpha = 0.0
        self.caloriesImage.alpha = 0.0
        self.fridgeDateLabel.alpha = 0.0
        self.fridgeImage.alpha = 0.0

        UINavigationBar.appearance().barTintColor = UIColor(red: 1/255, green: 174/255, blue: 240/255, alpha: 1)
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.title = recipeItem?.name
        self.recipeImageView.image = recipeImage
        self.recipeDescription.text = recipeItem?.description
        if (servingSize == 1){
            servingSizeLabel.text = "When serving for \(servingSize) person"
        } else {
            servingSizeLabel.text = "When serving for \(servingSize) people"
        }
        let calories = Int((recipeItem?.cookTime)!)!
        self.cookTimeLabel.text = "\(calories * servingSize) Mins"
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
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
