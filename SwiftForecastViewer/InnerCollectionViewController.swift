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
    var forecastData = [hourData]()
    var isFahrenheit = true

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func updateCollection(forecastArray: [hourData]) {
        forecastData = forecastArray
    }

    // MARK: - UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 1 {
            return CGSize.zero  // Remove header for second section

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
        
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionViewScrollPosition.centeredHorizontally)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! InnerCell
        let index = indexPath.row + (indexPath.section * 4)
        
        if !(self.forecastData.isEmpty) && (index < self.forecastData.count) {
            let hour = self.forecastData[index]
            let data = NSData(contentsOf: hour.icon)
            
            var temp = hour.english
            if !isFahrenheit {
                temp = hour.metric
            }
            
            DispatchQueue.global().async {
                DispatchQueue.main.async {
                    cell.icon.image = UIImage(data: data as! Data)
                    cell.time.text = hour.time
                    cell.temperature.text = temp

                }
            }
        }
        
    
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderView", for: indexPath as IndexPath) as! DayNameReusableView
            
            //Add grey borders
            let topBorder = CALayer()
            let topWidth = CGFloat(1.0)
            topBorder.borderColor = UIColor.darkGray.cgColor
            topBorder.frame = CGRect(x: 0, y: 0, width:  headerView.frame.size.width, height: headerView.frame.size.height)
            topBorder.borderWidth = topWidth
            headerView.layer.addSublayer(topBorder)
            headerView.layer.masksToBounds = true
            
            let bottomBorder = CALayer()
            let bottomWidth = CGFloat(2.0)
            bottomBorder.borderColor = UIColor.darkGray.cgColor
            bottomBorder.frame = CGRect(x: 0, y: headerView.frame.size.height - bottomWidth, width:  headerView.frame.size.width, height: headerView.frame.size.height)
            bottomBorder.borderWidth = bottomWidth
            headerView.layer.addSublayer(bottomBorder)
            headerView.layer.masksToBounds = true
            
            
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
