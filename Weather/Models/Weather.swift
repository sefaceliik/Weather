//
//  Weather.swift
//  Weather
//
//  Created by Sefa MacBook Pro on 11.03.2021.
//

import Foundation


struct Weather: Codable {
    var name : String
    var cod : Int
    var main : Details
    var coord : Coordinatees
}

struct Coordinatees: Codable {
    var lon : Double
    var lat : Double
}

struct Details: Codable {
    var temp : Double
    var feels_like : Double
    var temp_min : Double
    var temp_max : Double
    var pressure : Int 
    var humidity : Int
}


