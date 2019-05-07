//
//  ViewController.swift
//  Weather
//
//  Created by Egor Pats on 5/6/19.
//  Copyright © 2019 Egor Pats. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchBar.delegate = self
    }


}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        
        var locationName: String?
        var currentTemp: Double?
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
                if let current = json["current"] {
                    currentTemp = current["temp_c"] as? Double
                    
                    
                }
                DispatchQueue.main.async {
                    if errorHasOccured {
                        self?.cityLabel.text = "The request failed"
                        self?.tempLabel.isHidden = true
                        
                    } else {
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
