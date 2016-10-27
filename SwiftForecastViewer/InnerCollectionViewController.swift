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
    var today = [hourData]()
    var tomorrow = [hourData]()

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
            today = forecasts.today
            updateCollection(forecastArray: today)
        } else {
            tomorrow = forecasts.tomorrow
            updateCollection(forecastArray: tomorrow)
        }
    }
    
    func updateCollection(forecastArray: [hourData]) {
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
        
        //testing
        let index = indexPath.row + indexPath.section
        print(index)
        
        
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionViewScrollPosition.centeredHorizontally)
        
        if !(today.isEmpty) {
            self.asyncUpdateCollection(for: cell, array: today, itemIndex: index)
        }
        else {
            self.asyncUpdateCollection(for: cell, array: tomorrow, itemIndex: index)
        }
        
        //testing
        cell.backgroundColor = UIColor.lightGray
    
        return cell
    }
    
    func asyncUpdateCollection(for cell:InnerCell, array: [hourData], itemIndex: Int) {
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                
                if itemIndex < array.count {
                    
                    let hour = array[itemIndex]
                    cell.time.text = hour.time
                    cell.temperature.text = hour.temp
                    
                    let data = NSData(contentsOf: hour.icon)
                    cell.icon.image = UIImage(data: data as! Data)
                }
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
