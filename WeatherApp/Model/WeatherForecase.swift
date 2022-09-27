//
//  WeatherForecase.swift
//  WeatherApp
//
//  Created by Nguyễn Duy Việt on 21/09/2022.
//

import Foundation

class WeatherForecast {
    var day = ""
    var imgWeather = ""
    var probOfRain = ""
    var minTemp = ""
    var maxTemp = ""
    
    init(day: String, imgWeather: String, probOfRain: String, minTemp: String, maxTemp: String) {
        self.day = day
        self.imgWeather = imgWeather
        self.probOfRain = probOfRain
        self.minTemp = minTemp
        self.maxTemp = maxTemp
    }
}
