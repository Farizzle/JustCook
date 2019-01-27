//
//  UserPreferencesViewController.swift
//  JustCook
//
//  Created by Metricell Developer on 08/01/2019.
//  Copyright © 2019 Faris Zaman. All rights reserved.
//

import UIKit

class UserPreferencesViewController: UIViewController {
    
    // -- UIELEMENTS --
    // Budget Section
    @IBOutlet weak var cheapButton: CustomButton!
    @IBOutlet weak var medianButton: CustomButton!
    @IBOutlet weak var expensiveButton: CustomButton!
    var selectedPrices: Bool = false
    var budgetIndicator: Int = 0
    @IBAction func toggleBudgetButtons(_ sender: AnyObject){
        guard let button = sender as? UIButton else {
            return
        }
        switch button.tag {
        case 0:
            cheapButton.isSelected = true
            medianButton.isSelected = false
            expensiveButton.isSelected = false
            budgetIndicator = 1
        case 1:
            cheapButton.isSelected = false
            medianButton.isSelected = true
            expensiveButton.isSelected = false
            budgetIndicator = 2
        case 2:
            cheapButton.isSelected = false
            medianButton.isSelected = false
            expensiveButton.isSelected = true
            budgetIndicator = 3
        default:
            print("Unknown tag for budget button")
            return
        }
        selectedPrices = true
    }

    // ServingSize Section
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
    
    // SelectedDates Section
    var selectedDatesList: NSMutableArray = []
    @IBAction func selectDates(_ sender: AnyObject){
        guard let button = sender as? UIButton else {
            return
        }
        if (!button.isSelected){
            button.isSelected = true
            selectedDatesList = refineSelectedDates(thisDate: button.titleLabel?.text ?? "", currentDates: selectedDatesList, buttonSelected: true)
        } else {
            button.isSelected = false
            selectedDatesList = refineSelectedDates(thisDate: button.titleLabel?.text ?? "", currentDates: selectedDatesList, buttonSelected: false)
        }
        
        if (servingSizeNumber > 0 && selectedPrices){
            UIView.animate(withDuration: 1.5, delay: 0, options: [.curveEaseIn], animations: {
                
                self.continueView.frame = CGRect.init(x: 0, y: self.view.frame.size.height - self.continueView.frame.size.height, width: self.view.frame.size.width, height: 93)
                
            }, completion: nil)
        }
    }
    
    private func refineSelectedDates(thisDate: String, currentDates: NSMutableArray, buttonSelected: Bool) -> NSMutableArray{
        if (buttonSelected){
            if (!currentDates.contains(thisDate)){
                currentDates.add(thisDate)
            }
            
            return currentDates
        } else {
            if (currentDates.contains(thisDate)){
                currentDates.remove(thisDate)
            }
            return currentDates
        }
    }
    // Bottombar Navigation
    @IBOutlet weak var continueView: UIView!
    @IBOutlet weak var continueButton: UIButton!{
        didSet{
            continueButton.layer.borderColor = UIColor.white.cgColor
        }
    }
    
    @IBAction func continueButtonAction(_ sender: Any) {
        CoreDataHelper.saveUser(entityName: "User", servingSize: servingSizeNumber, budget: budgetIndicator, selectedDate: "hello")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup launch UI elements
        self.navigationController?.navigationBar.topItem?.title = "About you"
        servingSize.text = "\(servingSizeNumber)"
        continueView.frame = CGRect.init(x: 0, y: self.view.frame.size.height+93, width: self.view.frame.size.width, height: 93)
    }


}

