//
//  ViewController.swift
//  ENBDAssignment
//
//  Created by Sharon on 22/03/2020.
//  Copyright © 2020 Sharon. All rights reserved.
//

import UIKit

class PhotoListViewController: UIViewController, UISearchBarDelegate {
    @IBOutlet weak var searchTextField: UISearchBar!
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView.register(UINib(nibName: "PhotoCell", bundle: .main), forCellWithReuseIdentifier: "PhotoCell")
        searchTextField.text = "Apple"
    }


}
extension PhotoListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView
           .dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath)
         cell.backgroundColor = .black

                return cell
    }
    
    
    
}

