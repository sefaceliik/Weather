//
//  ViewController.swift
//  Weather
//
//  Created by Sefa MacBook Pro on 11.03.2021.
//

import UIKit
import CoreData
import CoreLocation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var locationManager = CLLocationManager()
    var location = CLLocationCoordinate2D()
    var weatherArray : [Weather] = []
    var citiesArray = [String]()
    var idArray = [UUID]()
    var cityName: String = ""
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as! WeatherTableViewCell
        
        if weatherArray.isEmpty == true {
            
            cell.cityLabel.text = "test"
        } else {
            cell.cityLabel.text = "\(weatherArray[indexPath.row].name) : \(weatherArray[indexPath.row].main.temp)°C"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ChosenCity.shared.name = weatherArray[indexPath.row].name
        ChosenCity.shared.temp = weatherArray[indexPath.row].main.temp
        ChosenCity.shared.feels_like = weatherArray[indexPath.row].main.feels_like
        ChosenCity.shared.temp_min = weatherArray[indexPath.row].main.temp_min
        ChosenCity.shared.temp_max = weatherArray[indexPath.row].main.temp_max
        ChosenCity.shared.pressure = weatherArray[indexPath.row].main.pressure
        ChosenCity.shared.humidity = weatherArray[indexPath.row].main.humidity
        
        performSegue(withIdentifier: "toDetails", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        if CheckInternet.Connection(){
            getLocationWeather()
        } else {
            
            let alert = UIAlertController(title: "Internet", message: "You are not connected.", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        }
        
        //getLocationWeather()
    }
    
    func getCities(){
        
        
        citiesArray.removeAll()
        idArray.removeAll()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cities")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(fetchRequest)
            
            for result in results as! [NSManagedObject]{
                if let name = result.value(forKey: "name") as? String{
                    self.citiesArray.append(name)
                    print(name)
                }
                if let id = result.value(forKey: "id") as? UUID{
                    self.idArray.append(id)
                    print(id)
                }
                getData()
            }
            
        } catch{
            print("error get cities")
        }
    }
    
    func arrayControl(str: String) -> Bool{
        
        var flag = 0
        
        for weather in weatherArray{
            if weather.name == str{
                flag = flag+1
            }
        }
        if flag == 0 {
            return true
        } else{
            return false
        }
    }
    
    func firstTimeCity(){
        
        let apiKey = "7f4a42cc6427895ab50123aef22f79c1"
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&units=metric&appid=\(apiKey)")!
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: url) { (data, response, error) in
                
            if error == nil && data != nil {
                
                let decoder = JSONDecoder()
                do{
                                    
                    let weather = try decoder.decode(Weather.self, from: data!)
                    if self.arrayControl(str: weather.name){
                        
                        self.weatherArray.append(weather)

                    }
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.saveData()
                    }
                    
                                    
                                    
                } catch {
                    DispatchQueue.main.async {
                        self.alertFunc()
                    }
                }
            }
        }
        dataTask.resume()
    }
    
    func alertFunc(){
        
            let alert = UIAlertController(title: "Error", message: "City is invalid", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
    }
    
    
    func getLocationWeather(){
        
        let apiKey = "7f4a42cc6427895ab50123aef22f79c1"
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(location.latitude)&lon=\(location.longitude)&units=metric&appid=\(apiKey)")!
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: url) { (data, response, error) in
                
            if error == nil && data != nil {
                
                let decoder = JSONDecoder()
                do{
                                    
                    let weather = try decoder.decode(Weather.self, from: data!)
                    if self.arrayControl(str: weather.name){
                        
                        self.weatherArray.append(weather)

                    }

                    
                                    
                                    
                } catch {
                    print("error location api")
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        dataTask.resume()
        getCities()
    
    }
    
    
    func getData(){
            
        let apiKey = "7f4a42cc6427895ab50123aef22f79c1"
        
        for city in citiesArray{
            let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(city)&units=metric&appid=\(apiKey)")!
            let session = URLSession.shared
            
            let dataTask = session.dataTask(with: url) { (data, response, error) in
                    
                if error == nil && data != nil {
                    
                    let decoder = JSONDecoder()
                    do{
                                        
                        let weather = try decoder.decode(Weather.self, from: data!)
                        if self.arrayControl(str: weather.name){
                            
                            self.weatherArray.append(weather)

                        }
                        
                        
                                        
                                        
                    } catch {
                        print("error api")
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
            dataTask.resume()

        }
    }
    
    
    
    
    
    

    
    
    func saveData(){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newCity = NSEntityDescription.insertNewObject(forEntityName: "Cities", into: context)
        
        newCity.setValue(cityName, forKey: "name")
        newCity.setValue(UUID(), forKey: "id")
        
        do {
            try context.save()
            print("success")
        } catch{
            print("error save ")
        }
    }

    @IBAction func addButtonClicked(_ sender: Any) {
        
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Enter the city with English letters", message: "", preferredStyle: UIAlertController.Style.alert)
        
        let addItemAction = UIAlertAction(title: "Add Item", style: UIAlertAction.Style.default) { (action) in
            
            let city = textField.text!
            self.cityName = city.replacingOccurrences(of: " ", with: "%20")
            self.firstTimeCity()
            
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil)
        
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "Create a new item"
            textField = alertTextfield
            
        }
        
        alert.addAction(addItemAction)
        alert.addAction(cancelButton)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cities")
            
            let idString = idArray[indexPath.row-1].uuidString
            
            fetchRequest.predicate = NSPredicate(format: "id = %@", idString)
            fetchRequest.returnsObjectsAsFaults = false
            
            do{
                let results = try context.fetch(fetchRequest)
                if results.count > 0 {
                    for result in results as! [NSManagedObject]{
                        if let id = result.value(forKey: "id") as? UUID{
                            if id == idArray[indexPath.row-1]{
                                context.delete(result)
                                citiesArray.remove(at: indexPath.row-1)
                                idArray.remove(at: indexPath.row-1)
                                self.tableView.reloadData()
                                
                                
                                do{
                                    try context.save()
                                    print("Deleted")
                                } catch{
                                    print("Delete error ")
                                }
                                break
                            }
                        }
                    }
                }
            } catch{
               print("saving error")
            }
            
        
        }
    }
    
    
}

