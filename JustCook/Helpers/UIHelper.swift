//
//  UIHelper.swift
//  JustCook
//
//  Created by Metricell Developer on 08/01/2019.
//  Copyright © 2019 Faris Zaman. All rights reserved.
//

import UIKit

struct UIHelper {
    static public func animateLabel(label: UILabel, text: Int){
        UIView.animate(withDuration: 0.2, animations: {
            label.alpha = 0.0
        }) { (bool) in
            label.alpha = 1.0
            label.text = "\(text)"
        }
    }
}


