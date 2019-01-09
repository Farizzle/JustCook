//
//  CustomButton.swift
//  JustCook
//
//  Created by Metricell Developer on 09/01/2019.
//  Copyright © 2019 Faris Zaman. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    
    required init() {
        super.init(frame: .zero)
        setTitleColor(Colours.mainBlue, for: UIControl.State.normal)
        setBackgroundColor(color: UIColor.white, forState: UIControl.State.normal)
        setTitleColor(UIColor.white, for: UIControl.State.selected)
        setBackgroundColor(color: Colours.mainBlue, forState: UIControl.State.selected)
        layer.cornerRadius = 5.0
        clipsToBounds = true
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override open var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? Colours.mainBlue : UIColor.white
            titleLabel?.textColor = isSelected ? UIColor.white : Colours.mainBlue
        }
    }

    func setBackgroundColor(color: UIColor, forState: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        setBackgroundImage(colorImage, for: forState)
    }
}


