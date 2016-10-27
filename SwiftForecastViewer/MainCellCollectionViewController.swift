//
//  MainCellCollectionViewController.swift
//  SwiftForecastViewer
//
//  Created by Michael Castro on 10/25/16.
//  Copyright © 2016 Michael Castro. All rights reserved.
//

import UIKit

private let reuseIdentifier = "HourCell"

class MainCellCollectionViewController: UICollectionViewController {
    
    public var isTodayForecast: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // testing
        // CollectionView Data
        let collectionViewDataNotif = Notification.Name("UpdateCollectionView")
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateCollectionView(notification:)), name: collectionViewDataNotif, object: nil)
    }
    
    func updateCollectionView(notification: Notification) {
        print(notification)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 4
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)

        return cell
    }

    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let dayNameView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "DayNameView", for: indexPath) as! HeaderReusableView
        
        if !isTodayForecast {
            dayNameView.dayLabel.text = "Tomorrow"
        } else {
            dayNameView.dayLabel.text = "Today"
        }
        
        return dayNameView
    }
}












