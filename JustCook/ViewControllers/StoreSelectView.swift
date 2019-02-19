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
    
    @IBOutlet weak var tescoButton: UIButton!
    @IBOutlet weak var sainsburyButton: UIButton!
    @IBOutlet weak var asdaButton: UIButton!
    @IBOutlet weak var aldiButton: UIButton!
    @IBOutlet weak var waitroseButton: UIButton!
    
    var userDetails:[NSManagedObject] = []
    var servingSize = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userDetails = CoreDataHelper.loadCoreData(entityName: "User");
        servingSize = (userDetails[userDetails.count-1].value(forKey: "servingSize") as! Int)
        self.currentServingSize.text = "\(servingSize)"
    }
    
    @IBAction func decreaseServing(_ sender: Any) {
        if (servingSize < 0){
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
    
    @IBAction func selectSuperMarket(_ sender: Any){
        
    }
}
