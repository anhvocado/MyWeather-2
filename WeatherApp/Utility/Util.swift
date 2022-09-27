//
//  Util.swift
//  WeatherApp
//
//  Created by Nguyễn Duy Việt on 22/09/2022.
//

import Foundation
import UIKit

class Util {
    static func roundCorner(views: [UIView], radius: CGFloat) {
        for myView in views {
            myView.layer.masksToBounds = true
            myView.layer.cornerRadius = radius
        }
    }
}
