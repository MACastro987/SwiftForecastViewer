//
//  InnerCollectionViewController.swift
//  SwiftForecastViewer
//
//  Created by Michael Castro on 10/26/16.
//  Copyright © 2016 Michael Castro. All rights reserved.
//

import UIKit

private let reuseIdentifier = "InnerCell"

class InnerCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    public var isTodayForecast = true
    var today = [hourData]()
    var tomorrow = [hourData]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if section == 1 {
            return CGSize.zero
        } else {
            return CGSize(width: collectionView.frame.size.width, height: 50.0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenRect = UIScreen.main.bounds
        let screenWidth = screenRect.width
        let cellWidth = screenWidth/5 // Making four equal columns
        let size: CGSize = CGSize(width: cellWidth, height: cellWidth)
        
        return size
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! InnerCell
        
        let index = indexPath.row + indexPath.section
        
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
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderView", for: indexPath as IndexPath) as! DayNameReusableView
            
            if isTodayForecast {
                headerView.dayLabel.text = "Today"
            } else {
                headerView.dayLabel.text = "Tomorrow"
            }
            
            return headerView
        }
        else {
            assert(false, "error setting element properties")
        }
    }
}
