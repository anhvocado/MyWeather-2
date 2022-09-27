//
//  HourWeather.swift
//  WeatherApp
//
//  Created by Nguyễn Duy Việt on 21/09/2022.
//

import Foundation

class HourWeather {
    var time = ""
    var currWeather = ""
    var degree = ""
    
    init(time: String, currWeather: String, degree: String) {
        self.time = time
        self.currWeather = currWeather
        self.degree = degree
    }
}
