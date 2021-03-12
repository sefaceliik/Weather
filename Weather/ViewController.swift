//
//  ViewController.swift
//  Weather
//
//  Created by Sefa MacBook Pro on 11.03.2021.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var weatherArray : Weather?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getData()
        tableView.reloadData()
    }
    
    func getData(){
            
        let cityName = "Istanbul"
        let apiKey = "7f4a42cc6427895ab50123aef22f79c1"
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&units=metric&appid=\(apiKey)")!
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: url) { (data, response, error) in
                
            if error == nil && data != nil {
                
                let decoder = JSONDecoder()
                do{
                                    
                    let weather = try decoder.decode(Weather.self, from: data!)
                    self.weatherArray = weather
                    print("Refreshed")
                    print(weather.name)
                    print(weather.main.temp)
                                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                                    
                                    
                } catch {
                    print("error")
                }
            }
        }
        dataTask.resume()
        tableView.reloadData()
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as! WeatherTableViewCell
        
        if weatherArray?.name != nil {
            cell.cityLabel.text =  "\(weatherArray!.name) : \(weatherArray!.main.temp)°C"
        } else {
            cell.cityLabel.text = ""
        }
        
        return cell
    }


}

