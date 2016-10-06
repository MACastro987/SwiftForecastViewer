//
//  ViewController.swift
//  SwiftForecastViewer
//
//  Created by Michael Castro on 10/5/16.
//  Copyright © 2016 Michael Castro. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    let reuseIdentifier = "MainCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
