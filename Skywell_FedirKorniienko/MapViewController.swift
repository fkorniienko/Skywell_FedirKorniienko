//
//  MapViewController.swift
//  
//
//  Created by Fedir Korniienko on 03.06.17.
//
//

import UIKit
import CoreData
class MapViewController: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textFieldCity: UITextField!
    @IBOutlet weak var labelTemperature: UILabel!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var labelCity: UILabel!
    @IBOutlet weak var buttonDone: UIButton!
    @IBOutlet weak var buttonFind: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var data = [NSManagedObject]()
    var id: String!
    private let apiKey = "3d6005c9fbc2698da41cca78d469d143"
    private let urlString = "http://api.openweathermap.org/data/2.5/weather?q="
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        buttonDone.addTarget(self, action: #selector(donePush), for: .touchUpInside)
        textFieldCity.delegate = self
        buttonFind.addTarget(self, action: #selector(findWeather), for: .touchUpInside)
        buttonDone.setTitle(NSLocalizedString("Done", comment: ""), for: .normal)
        buttonFind.setTitle(NSLocalizedString("Find", comment: ""), for: .normal)
        textFieldCity.placeholder = NSLocalizedString("Enter your city", comment: "")
    }


    func findWeather(){
        guard let city = textFieldCity.text else{return}
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        getWeather(city: city)
    }
    
    func getWeather(city: String) {
        
        let session = URLSession.shared
        guard let url = URL(string: ("\(urlString)\(city)&APPID=\(apiKey)"))else{
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            return}
//        let requestURL = URL(string: ("\(urlString)\(city)&APPID=\(apiKey)"))!
        let dataTask = session.dataTask(with: url) {
            
            (data: Data?, response: URLResponse?, error: Error?) in

            if error == nil {
                let json =  try? JSONSerialization.jsonObject(with: data!, options: []) as! [String: AnyObject]
                if json != nil  {
                    if let name = json!["name"] as? String {
                        self.labelCity.text = NSLocalizedString("city: " , comment: "") +  name
                    }
                    if let main = json!["main"] as? NSDictionary {
                        if let temp = main["temp"] as? Double {
                            self.labelTemperature.text = NSLocalizedString("temperature: " , comment: "")  +  String(format: "%.0f", temp - 273.15)
                        }
                    }
                    if let weather = json!["weather"] as? [NSDictionary] {
                        if let description = weather[0]["description"] as? String {
                            self.labelStatus.text = NSLocalizedString("description: " , comment: "")  + description
                        }
                    }
                    
                    
                }
                
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                
            }else{
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            }
        }
        dataTask.resume()
    }
    func donePush(){
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext{
        let weather = WeatherData(context: context)
            weather.city = self.labelCity.text!
            weather.status = self.labelStatus.text!
            weather.temperature = self.labelTemperature.text
            weather.id = id
        try! context.save()
        }
    self.navigationController?.popViewController(animated: true)
    }

}
