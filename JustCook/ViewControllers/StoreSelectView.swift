//
//  StoreSelectView.swift
//  JustCook
//
//  Created by Metricell Developer on 19/02/2019.
//  Copyright © 2019 Faris Zaman. All rights reserved.
//

import UIKit
import CoreData

class StoreSelectView: UIViewController {

    @IBOutlet weak var decreaseServingButton: UIButton!
    @IBOutlet weak var increaseServingButton: UIButton!
    @IBOutlet weak var currentServingSize: UILabel!
    @IBOutlet weak var hostingView: UIView!
    
    @IBOutlet weak var tescoButton: UIButton!
    @IBOutlet weak var sainsburyButton: UIButton!
    @IBOutlet weak var asdaButton: UIButton!
    @IBOutlet weak var aldiButton: UIButton!
    @IBOutlet weak var waitroseButton: UIButton!
    
    let userDetails:[NSManagedObject] = CoreDataHelper.loadCoreData(entityName: "User")
    var servingSize = Int()
    var delegate: StoreDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        servingSize = (userDetails[userDetails.count-1].value(forKey: "servingSize") as! Int)
        self.currentServingSize.text = "\(servingSize)"
        hostingView.layer.cornerRadius = 20
        hostingView.layer.masksToBounds = true
        hostingView.layer.borderColor = Colours.mainBlue.cgColor
        hostingView.layer.borderWidth = 3.0
    }
    
    @IBAction func decreaseServing(_ sender: Any) {
        if (servingSize > 0){
            servingSize -= 1
            self.currentServingSize.text = "\(servingSize)"
        }
    }
    
    @IBAction func increaseServing(_ sender: Any) {
        if (servingSize < 4){
            servingSize += 1
            self.currentServingSize.text = "\(servingSize)"
        }
    }
    
    // Triggers delegate to update the query field for the supermarket
    @IBAction func selectSuperMarket(_ sender: UIButton){
        switch sender.tag {
        case 0:
            updateSuperMarket(superMarket: "tesco")
            break
        case 1:
            updateSuperMarket(superMarket: "sainsburys")
            break
        case 2:
            updateSuperMarket(superMarket: "asda")
            break
        case 3:
            updateSuperMarket(superMarket: "aldi")
            break
        case 4:
            updateSuperMarket(superMarket: "waitrose")
            break
        default:
            break
        }
    }
    
    // Delegate to update the supermaket parameter in the query for ingredients
    func updateSuperMarket(superMarket: String){
        if let delegate = self.delegate {
            delegate.changeSuperMarket(superMarket: superMarket)
        }
        dismiss(animated: true, completion: nil)
    }
}
