//
//  RecipeDetailsViewController.swift
//  JustCook
//
//  Created by Metricell Developer on 27/01/2019.
//  Copyright © 2019 Faris Zaman. All rights reserved.
//

import UIKit

class RecipeDetailsViewController: UIViewController {
    
    public var recipeItem = Recipes()
    public var recipeImage = UIImage()
    @IBOutlet weak var recipeImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UINavigationBar.appearance().barTintColor = UIColor(red: 1/255, green: 174/255, blue: 240/255, alpha: 1)
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.title = recipeItem?.name
        self.recipeImageView.image = recipeImage
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
