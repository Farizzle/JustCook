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
    
    var userDetails:[NSManagedObject] = []
    var servingSize = Int()
    var delegate: StoreDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userDetails = CoreDataHelper.loadCoreData(entityName: "User");
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
    
    @IBAction func selectSuperMarket(_ sender: UIButton){
        switch sender.tag {
        case 0:
            print("Tesco Selected")
            updateSuperMarket(superMarket: "tesco")
            break
        case 1:
            print("Sainsburys Selected")
            updateSuperMarket(superMarket: "sainsburys")
            break
        case 2:
            print("Asda Selected")
            updateSuperMarket(superMarket: "asda")
            break
        case 3:
            print("Aldi Selected")
            updateSuperMarket(superMarket: "aldi")
            break
        case 4:
            print("Waitrose Selected")
            updateSuperMarket(superMarket: "waitrose")
            break
        default:
            break
        }
    }
    
    func updateSuperMarket(superMarket: String){
        if let delegate = self.delegate {
            delegate.changeSuperMarket(superMarket: superMarket)
        }
        dismiss(animated: true, completion: nil)
    }
}
