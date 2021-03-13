//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Sefa MacBook Pro on 14.03.2021.
//

import Foundation


struct WeatherListViewModel {
    let weatherList: [Weather]
    
    func numberOfRowsInSection() -> Int {
         return self.weatherList.count
     }
     
     func cryptoAtIndex(_ index: Int) -> CryptoViewModel {
         let weather = self.weatherList[index]
         return CryptoViewModel(weather)
     }
}

struct CryptoViewModel {
    let weatherM: ChosenCity
    
    init(_ weat: ChosenCity) {
        self.weatherM = weat
    }
    
    var name: String {
        return self.weatherM.name
    }
    
    var temp: Double {
        return self.weatherM.temp
    }
    
    var feels_like: Double{
        return self.weatherM.feels_like
    }
    
    var temp_min: Double{
        return self.weatherM.temp_min
    }
    
    var temp_max: Double{
        return self.weatherM.temp_max
    }
    
    var pressure: Int{
        return self.weatherM.pressure
    }
    
    var humidity: Int{
        return self.weatherM.humidity
    }
    
}

