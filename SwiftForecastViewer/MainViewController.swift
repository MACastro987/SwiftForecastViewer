//
//  ViewController.swift
//  SwiftForecastViewer
//
//  Created by Michael Castro on 10/5/16.
//  Copyright © 2016 Michael Castro. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
        
    let reuseIdentifier = "MainCell"
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let weatherRequest = WeatherRequest()
        
        weatherRequest.requestWeather(forKey: .conditions)
//        weatherRequest.requestWeather(forKey: .hourly)
        
        let notificationName = Notification.Name("UpdateUI")

        NotificationCenter.default.addObserver(self, selector: #selector(self.updateUI(notification:)), name: notificationName, object: nil)
    }
    
    func updateUI(notification: Notification) {
        let currentArray: CurrentDisplayData = notification.object as! CurrentDisplayData
        
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                self.tempLabel.text = currentArray.temperature
                self.weatherLabel.text = currentArray.weather
                self.locationLabel.text = currentArray.cityAndState
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        return cell
    }
}
