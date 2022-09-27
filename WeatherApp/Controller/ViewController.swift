//
//  ViewController.swift
//  WeatherApp
//
//  Created by Nguyễn Duy Việt on 21/09/2022.
// ừhkfhfsđ

import UIKit
import Alamofire
import CoreLocation
import MapKit


class ViewController: UIViewController, CityListener {
    func listener(lat: String, lng: String) {
        print("View controller: lat \(lat) --- lng \(lng)")
    }

    
    
    
    
    @IBOutlet weak var tableFiveDayForecast: UITableView!
    @IBOutlet weak var hourWeatherView: UIView!
    @IBOutlet var hourWeatherCollectionView: UICollectionView!
    @IBOutlet weak var viewForecast: UIView!
    @IBOutlet weak var viewTabBar: Gradient!
    @IBOutlet weak var viewTemperature: UIView!
    @IBOutlet weak var imgPreviewMap: UIImageView!
   
    @IBAction func addCity(_ sender: UIBarButtonItem) {
        let vc = CityViewController()
        vc.cityListener = self
        vc.title = "City"
        self.navigationController?.pushViewController(vc, animated: true)
        }

    
    var arrCities = [City]()
    var arrHourWeather = [HourWeather]()
    var arrWeatherForecast = [WeatherForecast]()
    
    let locationManager = CLLocationManager()
    var coordinates: CLLocationCoordinate2D?
    
    let options = MKMapSnapshotter.Options()
    

//    var currentCoordinate: CLLocation?
    
    
    override func viewDidLoad() {
        

        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupViews()
        setupData()
        setupEvent()
        getCurrLocation()
        

        
//        currentCoordinate = LocationManager().getCurrentLocation()
//        print(currentCoordinate)
//        print("Hello")
        
        //let distance = currentCoordinate?.distance(from: <#T##CLLocation#>)

        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        UINavigationBar.appearance().standardAppearance = appearance
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    
    func setupViews() {
        setupHourWeatherCollectionView()
        setupTableFiveDayForecast()
        roundViewCorner()
        view.bringSubviewToFront(viewTabBar)
    }
    
    func setupData() {
        bindHourWeatherData()
        bindWeatherForecastData()
    }
    
    func setupHourWeatherCollectionView() {
        hourWeatherCollectionView.delegate = self
        hourWeatherCollectionView.dataSource = self

    }
    
    func setupTableFiveDayForecast() {
        tableFiveDayForecast.delegate = self
        tableFiveDayForecast.dataSource = self
    }
    
    func bindHourWeatherData() {
        let w1 = HourWeather(time: "9AM", currWeather: "rainy-day", degree: "20°")
        let w2 = HourWeather(time: "12AM", currWeather: "rainy-day", degree: "20°")
        let w3 = HourWeather(time: "3PM", currWeather: "rainy-day", degree: "20°")
        let w4 = HourWeather(time: "6PM", currWeather: "rainy-day", degree: "20°")
        
        let w5 = HourWeather(time: "9PM", currWeather: "rainy-day", degree: "20°")
        let w6 = HourWeather(time: "12AM", currWeather: "rainy-day", degree: "20°")
        let w7 = HourWeather(time: "3AM", currWeather: "rainy-day", degree: "20°")
        let w8 = HourWeather(time: "^PM", currWeather: "rainy-day", degree: "20°")
        
        arrHourWeather.append(w1)
        arrHourWeather.append(w2)
        arrHourWeather.append(w3)
        arrHourWeather.append(w4)
        arrHourWeather.append(w5)
        arrHourWeather.append(w6)
        arrHourWeather.append(w7)
        arrHourWeather.append(w8)
        
        hourWeatherCollectionView.reloadData()
        
    }
    
    func bindWeatherForecastData() {
        let wf1 = WeatherForecast(day: "Today", imgWeather: "raining", probOfRain: "40%", minTemp: "10°", maxTemp: "20°")
        let wf2 = WeatherForecast(day: "Thu", imgWeather: "sun", probOfRain: "", minTemp: "10°", maxTemp: "20°")
        let wf3 = WeatherForecast(day: "Fri", imgWeather: "raining", probOfRain: "40%", minTemp: "10°", maxTemp: "20°")
        let wf4 = WeatherForecast(day: "Sat", imgWeather: "sun", probOfRain: "", minTemp: "10°", maxTemp: "20°")
        let wf5 = WeatherForecast(day: "Sun", imgWeather: "raining", probOfRain: "40%", minTemp: "10°", maxTemp: "20°")
        
        arrWeatherForecast.append(wf1)
        arrWeatherForecast.append(wf2)
        arrWeatherForecast.append(wf3)
        arrWeatherForecast.append(wf4)
        arrWeatherForecast.append(wf5)
        
        tableFiveDayForecast.reloadData()
        
    }
    
    func roundViewCorner() {
        Util.roundCorner(views: [hourWeatherView, viewForecast, viewTemperature], radius: 20)
        Util.roundCorner(views: [imgPreviewMap], radius: 10)
    }

    func setupEvent() {
        tapOnImgPreviewMap()
        tapOnViewTemperature()
    }
    
    func tapOnViewTemperature() {
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(gotoMapView))
        viewTemperature.addGestureRecognizer(tapGes)
    }
    
    func tapOnImgPreviewMap() {
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(gotoMapView))
        imgPreviewMap.addGestureRecognizer(tapGes)
    }
    
    @objc func gotoMapView() {
        let vc = MapVC(nibName: "MapVC", bundle: nil)
        vc.coordinates = coordinates
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tapOnMap(_ sender: Any) {
        let vc = MapVC(nibName: "MapVC", bundle: nil)
        vc.coordinates = coordinates
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tapOnCategory(_ sender: Any) {
        print("go to category")
    }
    
    func getCurrLocation() {
        // Ask for Authorisation from the User.
        locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrHourWeather.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = hourWeatherCollectionView.dequeueReusableCell(withReuseIdentifier: "hourWeatherCell", for: indexPath) as! HourWeatherCell
        let data = arrHourWeather[indexPath.item]
        
        cell.lbTime.text = data.time
        cell.imgWeather.image = UIImage(named: "\(data.currWeather)")
        cell.lbDegree.text = data.degree
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let w = (view.frame.width - 30) / 2
        return CGSize(width: 45, height: 45)
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrWeatherForecast.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableFiveDayForecast.dequeueReusableCell(withIdentifier: "forecastCell") as! WeatherForecastCell
        let data = arrWeatherForecast[indexPath.row]
        
        if data.probOfRain == "" {
            cell.lbProbOfRain.isHidden = true
            cell.imgWeather.centerYAnchor.constraint(equalTo: cell.lbDay.centerYAnchor).isActive = true
        }
        
        cell.lbDay.text = data.day
        cell.imgWeather.image = UIImage(named: "\(data.imgWeather)")
        cell.lbProbOfRain.text = data.probOfRain
        cell.lbMinTemp.text = data.minTemp
        cell.lbMaxTemp.text = data.maxTemp
        
        cell.selectionStyle = .none
        
        return cell
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        coordinates = locValue
        
        options.region = MKCoordinateRegion(center: coordinates!, latitudinalMeters: CLLocationDistance(exactly: 100)!, longitudinalMeters: CLLocationDistance(exactly: 100)!)
        options.size = CGSize(width: view.frame.width - 40, height: 200)
        options.mapType = .standard
        options.showsBuildings = true
        
        let snapshotter = MKMapSnapshotter(options: options)
        
        snapshotter.start { snapshot, error in
           if let snapshot = snapshot {
               self.imgPreviewMap.image = snapshot.image
           }
        }
    }
}



//    func getCountryData() {
//        if let url = URL(string: "https://raw.githubusercontent.com/Viet20021476/github_Viet20021476.github.io/master/city.list.json") {
//            AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil, interceptor: nil, requestModifier: nil).responseJSON { response in
//                let dict = response.value as! [NSDictionary]
//                self.arrCities = dict.map( { City.deserialize(from: $0)! } )
//            }
//        }
//    }
        

