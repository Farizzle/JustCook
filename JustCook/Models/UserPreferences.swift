//
//  UserPreferences.swift
//  JustCook
//
//  Created by Metricell Developer on 10/01/2019.
//  Copyright © 2019 Faris Zaman. All rights reserved.
//

import UIKit

class UserPreferences: NSObject {
    
    public var servingSize: Int!
    public var budgetPrice: Int!
    public var selectedDates: Array<String>!
    
    init(servingSize: Int, budgetPrice: Int, selectedDates: Array<String>) {
        self.servingSize = servingSize
        self.budgetPrice = budgetPrice
        self.selectedDates = selectedDates
    }

}
