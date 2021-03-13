//
//  DetailsViewController.swift
//  Weather
//
//  Created by Sefa MacBook Pro on 12.03.2021.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var tempMinLabel: UILabel!
    @IBOutlet weak var tempMaxLabel: UILabel!
    @IBOutlet weak var tempFeelLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setValue()
        
    }
    

    func setValue(){
        cityLabel.text = "\(ChosenCity.shared.name)"
        tempLabel.text = "\(ChosenCity.shared.temp)°C"
        tempMinLabel.text = "\(ChosenCity.shared.temp_min)°C"
        tempMaxLabel.text = "\(ChosenCity.shared.temp_max)°C"
        tempFeelLabel.text = "\(ChosenCity.shared.feels_like)°C"
        pressureLabel.text = "\(ChosenCity.shared.pressure)°C"
        humidityLabel.text = "\(ChosenCity.shared.humidity)°C"
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
