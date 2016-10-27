//
//  InnerCollectionViewController.swift
//  SwiftForecastViewer
//
//  Created by Michael Castro on 10/26/16.
//  Copyright © 2016 Michael Castro. All rights reserved.
//

import UIKit

private let reuseIdentifier = "InnerCell"

class InnerCollectionViewController: UICollectionViewController {
    
    public var isTodayForecast = true
    var forecast = [hourData]()
    var newForecast = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // testing
        // CollectionView Data
        let collectionViewDataNotif = Notification.Name("UpdateCollectionView")
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateCollectionView(notification:)), name: collectionViewDataNotif, object: nil)
    }

    func updateCollectionView(notification: Notification) {
        
        guard let forecasts = notification.object as? forecastData else { return }
        
        if !isTodayForecast {
            let tomorrow = forecasts.tomorrow
            updateCollection(forecastArray: tomorrow)
        } else {
            let today = forecasts.today
            updateCollection(forecastArray: today)
        }
    }
    
    func updateCollection(forecastArray: [hourData]) {
        forecast = forecastArray
        newForecast = true
        collectionView?.reloadData()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        print(indexPath)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! InnerCell
        
        let itemIndex = indexPath.row + (indexPath.section * 4)
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionViewScrollPosition.centeredHorizontally)
        
        if !(forecast.isEmpty) {
            self.asyncUpdateCollection(for: cell, as: itemIndex)
        }
        else {
            print("No new forecast datea")
        }
        
        //testing
        cell.backgroundColor = UIColor.lightGray
    
        return cell
    }
    
    func asyncUpdateCollection(for cell:InnerCell, as itemIndex: Int) {
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                
                let hour = self.forecast[itemIndex]
                cell.time.text = hour.time
                cell.temperature.text = hour.temp
                
                let data = NSData(contentsOf: hour.icon)
                cell.icon.image = UIImage(data: data as! Data)
            }
        }
    }
    
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        switch kind {
            
        case UICollectionElementKindSectionHeader:
            
            let headerView: HeaderReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath as IndexPath) as! HeaderReusableView
            
            headerView.dayLabel.text = "Test"
            
            return headerView
            
        case UICollectionElementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Footer", for: indexPath as IndexPath) 
            
            footerView.backgroundColor = UIColor.green;
            return footerView
            
        default:
            assert(false, "Unexpected element kind")
        }
    }
}
