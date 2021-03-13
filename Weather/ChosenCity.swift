//
//  ChosenCity.swift
//  Weather
//
//  Created by Sefa MacBook Pro on 12.03.2021.
//

import Foundation


class ChosenCity {
    
    static let shared = ChosenCity()
    
    var name : String
    var temp : Double
    var feels_like : Double
    var temp_min : Double
    var temp_max : Double
    var pressure : Int
    var humidity : Int
    
    private init(){
        self.name = ""
        self.temp = 0.0
        self.temp_min = 0.0
        self.temp_max = 0.0
        self.feels_like = 0.0
        self.pressure = 0
        self.humidity = 0
    }
    
}
