//
//  UserPreferencesViewController.swift
//  JustCook
//
//  Created by Metricell Developer on 08/01/2019.
//  Copyright © 2019 Faris Zaman. All rights reserved.
//

import UIKit

class UserPreferencesViewController: UIViewController {
    
    //Serving size info
    var servingSizeNumber: Int = 0
    @IBOutlet weak var servingSize : UILabel!
    @IBAction func increaseServing(_ sender: Any) {
        if (servingSizeNumber < 4){
            servingSizeNumber += 1
            UIHelper.animateLabel(label: servingSize, text: servingSizeNumber)
        }
    }
    @IBAction func decreaseServing(_ sender: Any) {
        if (servingSizeNumber > 0){
            servingSizeNumber -= 1
            UIHelper.animateLabel(label: servingSize, text: servingSizeNumber)
        }
    }
    
    //Budget buttons
    @IBOutlet weak var cheapButton: CustomButton!

    @IBOutlet weak var medianButton: CustomButton!

    @IBOutlet weak var expensiveButton: CustomButton!
    
    @IBAction func toggleBudgetButtons(_ sender: AnyObject){
        guard let button = sender as? UIButton else {
            return
        }
        switch button.tag {
            case 0:
                cheapButton.isSelected = true
                medianButton.isSelected = false
                expensiveButton.isSelected = false
            case 1:
                cheapButton.isSelected = false
                medianButton.isSelected = true
                expensiveButton.isSelected = false
            case 2:
                cheapButton.isSelected = false
                medianButton.isSelected = false
                expensiveButton.isSelected = true
            default:
            print("Unknown tag for budget button")
            return
        }
    }
    
    @IBAction func selectDates(_ sender: AnyObject){
        guard let button = sender as? UIButton else {
            return
        }
        if (!button.isSelected){
            button.isSelected = true
        } else {
            button.isSelected = false
        }
    }
    
    @IBOutlet var daysInWeek: Array<UIButton>!{
        didSet{
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup launch UI elements
        self.navigationController?.navigationBar.topItem?.title = "About you"
        servingSize.text = "\(servingSizeNumber)"
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

