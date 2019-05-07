//
//  ViewController.swift
//  Weather
//
//  Created by Egor Pats on 5/6/19.
//  Copyright © 2019 Egor Pats. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var SwitchMod: UISwitch!
    @IBOutlet weak var switchLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
    var whiteColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    var blackColor = #colorLiteral(red: 0.1215686275, green: 0.1294117647, blue: 0.1411764706, alpha: 1)
    var blackForLabels = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    var whiteForLabels = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    
    var swithIs: Int!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        checkSwitchMod()
        searchBar.delegate = self
    }
    
    @IBAction func SwitchOn(_ sender: Any) {
        if SwitchMod.isOn == true {
            
            
            mainView.backgroundColor = blackColor
            cityLabel.textColor = whiteForLabels
            tempLabel.textColor = whiteForLabels
            switchLabel.textColor = whiteForLabels
            searchBar.barStyle = .black
            
            swithIs = 1
            UserDefaults.standard.set(swithIs, forKey: "mode")
        } else {
            
            mainView.backgroundColor = whiteColor
            cityLabel.textColor = blackForLabels
            tempLabel.textColor = blackForLabels
            switchLabel.textColor = blackForLabels
            searchBar.barStyle = .default
            
            swithIs = 2
            UserDefaults.standard.set(swithIs, forKey: "mode")
        }
       
    }
    
    func checkSwitchMod() {
        if UserDefaults.standard.integer(forKey: "mode") == 1 {
            mainView.backgroundColor = blackColor
            cityLabel.textColor = whiteForLabels
            tempLabel.textColor = whiteForLabels
            switchLabel.textColor = whiteForLabels
            searchBar.barStyle = .black
            SwitchMod.isOn = true
        } else {
            mainView.backgroundColor = whiteColor
            cityLabel.textColor = blackForLabels
            tempLabel.textColor = blackForLabels
            switchLabel.textColor = blackForLabels
            searchBar.barStyle = .default
            SwitchMod.isOn = false
        }
    }
    
    

}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        
        var locationName: String?
        var currentTemp: Double?
        var urlForImage: String?
        var dataImage: Data?
        var errorHasOccured: Bool = false
        
        let urlSearch =     "https://api.apixu.com/v1/current.json?key=cb09fdee98dc48b6b88201642190605&q=\(searchBar.text!.replacingOccurrences(of: " ", with: "%20"))"
            let url = URL(string: urlSearch)

        let task = URLSession.shared.dataTask(with: url!) {[weak self] (data, response, error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                    as! [String : AnyObject]
                print("json init!")
                
                if let _ = json["error"] {
                    errorHasOccured = true
                    
                }
                
                if let location = json["location"] {
                    locationName = location["name"] as? String
                }
                
                if let imageAPIcurrent = json["current"]{
                    if let imageAPI = imageAPIcurrent["condition"] as? [String : AnyObject]{
                        urlForImage  = "https:\(imageAPI["icon"] as? String ?? "//lh3.googleusercontent.com/lWuxzuZml5BM8LiHiNkWTqC91n0IxxSnZ2j-_OTGjOnz1vqidMNilL_H0HnH8fQj7uM")"
                        let urlImage = URL(string: urlForImage!)
                        dataImage = try? Data(contentsOf: urlImage!)
                    }
                }
                
                if let current = json["current"] {
                    currentTemp = current["temp_c"] as? Double
                }
                DispatchQueue.main.async {
                    if errorHasOccured {
                        let urlErrorImage = URL(string: "https://lh3.googleusercontent.com/lWuxzuZml5BM8LiHiNkWTqC91n0IxxSnZ2j-_OTGjOnz1vqidMNilL_H0HnH8fQj7uM")
                        dataImage = try? Data(contentsOf: urlErrorImage!)
                        self?.weatherImage.image = UIImage(data: dataImage!)
                        self?.cityLabel.text = "The request failed"
                        self?.tempLabel.isHidden = true
                        
                    } else {
                        self?.weatherImage.image = UIImage(data: dataImage!)
                        self?.cityLabel.text = locationName
                        self?.tempLabel.text = "\(currentTemp!)"
                        self?.tempLabel.isHidden = false
                        self?.searchBar.text = ""
                        
                        
                    }

                }
                
            } catch let jsonError {
                print(jsonError)
            }
        }
        task.resume()
        
    }
}
