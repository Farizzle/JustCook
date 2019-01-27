//
//  RecipeDetailsViewController.swift
//  JustCook
//
//  Created by Metricell Developer on 27/01/2019.
//  Copyright © 2019 Faris Zaman. All rights reserved.
//

import UIKit

class RecipeDetailsViewController: UIViewController {
    
    public var navTitle = String()
    public var recipeItem = Recipes()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UINavigationBar.appearance().barTintColor = UIColor(red: 1/255, green: 174/255, blue: 240/255, alpha: 1)
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.topItem?.title = navTitle
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
