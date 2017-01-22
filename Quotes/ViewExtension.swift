//
//  ViewExtension.swift
//  Quotes
//
//  Created by Sahil Gangele on 1/14/17.
//  Copyright © 2017 Sahil Gangele. All rights reserved.
//

import UIKit

extension UIView {
    
    func fadeIn(_ duration: TimeInterval = 0.20, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)  }
    
    func fadeOut(_ duration: TimeInterval = 0.20, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }

}
