//
//  MainViewController.swift
//  
//
//  Created by Fedir Korniienko on 03.06.17.
//
//

import UIKit
import CoreData
class MainViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelTemperature: UILabel!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var labelCity: UILabel!
    @IBOutlet weak var viewWeather: UIView!
    @IBOutlet weak var imageViewBackground: UIImageView!
    
    var carResult: NSFetchedResultsController<CarData>!
    var carData: [CarData] = []
    var weatherResult: NSFetchedResultsController<WeatherData>!
    var weatherData: [WeatherData] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.showWeather))
        viewWeather.addGestureRecognizer(tap)
        self.navigationItem.title = NSLocalizedString("CAR LIST", comment: "")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "add_icon"), style: .done, target: self, action: #selector(addCar))
        registrCell()
        getWeatherData()
        getCarData()
        carResult.delegate = self


    }
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if ((controller.fetchedObjects as? [CarData]) != nil){
        switch type {
        case .delete: guard let indexPath = indexPath else{break}
            tableView.deleteRows(at: [indexPath], with: .left)
        case .insert: guard let indexPath = newIndexPath else{break}
        tableView.insertRows(at: [indexPath], with: .left)
        case .update: guard let indexPath = newIndexPath else{break}
        tableView.reloadRows(at: [indexPath], with: .left)
        default:
            tableView.reloadData()
        }
        carData = controller.fetchedObjects as! [CarData]
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func getWeatherData(){
        let fetch: NSFetchRequest<WeatherData> = WeatherData.fetchRequest()
        let sort = NSSortDescriptor(key: "id", ascending: false)
        fetch.sortDescriptors = [sort]
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext{
        
                weatherResult = NSFetchedResultsController(fetchRequest: fetch, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
                try! weatherResult.performFetch()
                weatherData = weatherResult.fetchedObjects!
            }
        fillWeather()
    }
    
    func fillWeather(){
        guard let weather = weatherData.last else {
            return
        }
        labelCity.text = weather.city
        labelStatus.text = weather.status
        labelTemperature.text = weather.temperature
    }
    
    func getCarData(){
        let fetch: NSFetchRequest<CarData> = CarData.fetchRequest()
        let sort = NSSortDescriptor(key: "id", ascending: false)
        fetch.sortDescriptors = [sort]
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext{
            
            carResult = NSFetchedResultsController(fetchRequest: fetch, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            try! carResult.performFetch()
            carData = carResult.fetchedObjects!
        }
    }
    
    func showWeather(){
        if let destinationVC = storyboard?.instantiateViewController(withIdentifier: StoryboardIds.MapViewController) as? MapViewController {
            destinationVC.navigationItem.title = NSLocalizedString("Weather", comment: "")
            destinationVC.id = String(weatherData.count)
            self.navigationController?.pushViewController(destinationVC, animated: true)
        }
    }
    
    func addCar(){
        if let destinationVC = storyboard?.instantiateViewController(withIdentifier: StoryboardIds.AddCarViewController) as? AddCarViewController {
            destinationVC.id = String(carData.count)
            self.navigationController?.pushViewController(destinationVC, animated: true)
        }
    
    }
    func registrCell(){
        self.tableView?.register(UINib(nibName: "MainTableViewCell", bundle: nil), forCellReuseIdentifier: "MainTableViewCell")

        

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return carData.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 75
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tableData = carData[indexPath.row]
        
        if let cell: MainTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell") as? MainTableViewCell {
            cell.labelAutoPrice.text = tableData.price
            cell.labelAutoDescription.text = tableData.carModel
            guard let image = tableData.image as? [UIImage] else {return cell}
            cell.imageViewAuto.image = image.first
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if let destinationVC = storyboard?.instantiateViewController(withIdentifier: StoryboardIds.InfoCarViewController)as? InfoCarViewController {
                    destinationVC.navigationItem.title = NSLocalizedString("Info Car", comment: "")
                    destinationVC.carData = carData[indexPath.row]
                    self.navigationController?.pushViewController(destinationVC, animated: true)
                }
        
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext{
            
            let objToDelete = carResult.object(at: indexPath)
                context.delete(objToDelete)
                try! context.save()
            }
        }
    }

}
