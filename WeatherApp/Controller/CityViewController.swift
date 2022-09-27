
import UIKit
import CoreLocation



struct City: Decodable {
    let city: String
    let lat: String
    let lng: String
    let country: String
    let population: String
}

protocol CityListener {
    func listener(lat:String, lng: String)
}


class CityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var cityListener : CityListener? = nil
    
    var cities: [City] = []
    
    var filteredData = [String]()
    var isSearching = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        
        let jsonData = readLocalJSONFile(forName: "local")
        

        if let data = jsonData {
                cities = parse(jsonData: data)
                tableView.reloadData()
        }

        searchBar.delegate = self
        searchBar.enablesReturnKeyAutomatically = false
        
        // set delegate
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // set tableview size
        tableView.frame = view.frame
        tableView.keyboardDismissMode = .onDrag
        // set tableview
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
        self.view.addSubview(tableView)
        
        
        
        var currentCoordinate = LocationManager().getCurrentLocation()
        print("MY CURRENT: \(currentCoordinate)")
        
        cities = cities.sorted(by: {
            let distance1 = (currentCoordinate?.distance(from: CLLocation(latitude: Double($0.lat)! , longitude: Double($0.lng)! )) ?? .nan)
            let distance2 = (currentCoordinate?.distance(from: CLLocation(latitude: Double($1.lat)! , longitude: Double($1.lng)! )) ?? .nan)
            return (distance1 < distance2)
        }
        )
        tableView.reloadData()
        
        
        LocationManager.shared().startUpdating { (location) in
            var currentCoor = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            print("my currentCoor: \(currentCoor)")
//            print("latitude: \(location.coordinate.latitude), longitude: \(location.coordinate.longitude)")
            var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
            let ceo: CLGeocoder = CLGeocoder()
            center.latitude = location.coordinate.latitude
            center.longitude = location.coordinate.longitude
            
            let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
            print("My loc: \(loc)")
            ceo.reverseGeocodeLocation(loc, completionHandler:
                                        {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geocode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                
                if pm.count > 0 {
                    let pm = placemarks![0]
                    print(pm.locality)
                    var addressString : String = ""
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country!
                    }
                
                    print(addressString)
                }
            })
            
            
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredData.count
        } else {
            return cities.count
        }
    }
    
    // set tableview rows
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(UITableViewCell.self))! as UITableViewCell
        if isSearching {
            cell.textLabel?.text = filteredData[indexPath.row]
        } else {

            cell.textLabel?.text = """
                    \(cities[indexPath.row].city), \(cities[indexPath.row].country)
                    Latitude: \(cities[indexPath.row].lat), Longitude: \(cities[indexPath.row].lng)
                    Population: \(cities[indexPath.row].population)
                    """
            
            
            //let cityCoor = CLLocation(latitude: cities[indexPath.row].lat, longitude: cities[indexPath.row].lng)
        }
        

        cell.textLabel?.sizeToFit()
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // called when tableview cell was tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row) cell was selected")
        cityListener?.listener(lat: cities[indexPath.row].lat, lng: cities[indexPath.row].lng)
//        let vc = ViewController()
//        self.navigationController?.pushViewController(vc, animated: true)
        navigationController?.popViewController(animated: true)
        
    }
}
    
extension CityViewController: UISearchBarDelegate {
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            if searchBar.text == "" {
                isSearching = false
                tableView.reloadData()
            } else {
                isSearching = true
//                filteredData = cities.filter { (city: String) in
//                    return city.contains(searchText ?? "")
//                }
                filteredData = []
                let cities = cities.filter({$0.city.contains(searchText )})
                filteredData = cities.map({ city in
                    city.city
                })
//               filteredData = cities.filter({$0.prefix(searchText.count) == searchText})
                tableView.reloadData()
            }
        }
    }

extension CityViewController {
//    private enum Key: String, CodingKey {
//        case names = "city"
//    }
//
//    init(from decoder: Decoder) throws {
//      let container = try decoder.container(keyedBy: Key.self)
//      self.names = try container.decode([String].self, forKey: .names)
//    }
    
    func parse(jsonData: Data) -> [City] {
        do {
            let decodedData = try JSONDecoder().decode( [City].self, from: jsonData)
            self.cities = decodedData
//            for city in cities {
//                print(city.city)
//            }
//            filteredData = decodedData.filter({$0.contains(searchBar.text ?? "")})
//          print(decodedData)
            return decodedData
        } catch {
            print("error: \(error)")
        }
        return []
    }
    
    func readLocalJSONFile(forName name: String) -> Data? {
        do {
            if let filePath = Bundle.main.path(forResource: name, ofType: "json") {
                let fileUrl = URL(fileURLWithPath: filePath)
                let data = try Data(contentsOf: fileUrl)
                
                return data
            }
        } catch {
            print("error: \(error)")
        }
        return nil
    }
}
    


