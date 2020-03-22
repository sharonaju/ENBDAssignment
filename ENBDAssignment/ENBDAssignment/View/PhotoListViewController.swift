//
//  ViewController.swift
//  ENBDAssignment
//
//  Created by Sharon on 22/03/2020.
//  Copyright © 2020 Sharon. All rights reserved.
//

import UIKit

class PhotoListViewController: UIViewController, UISearchBarDelegate {
    
    // MARK: Properties

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchTextField: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    var viewModel: PhotoListViewModel = PhotoListViewModel()

    // MARK:
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView.register(UINib(nibName: "PhotoCell", bundle: .main), forCellWithReuseIdentifier: "PhotoCell")
        searchTextField.text = "Apple"
        prepareUI()
        search(keyWord: searchTextField.text ?? "")
    }
    
    func prepareUI() {
        viewModel.updateLoadingStatus = { [weak self] () in
                   DispatchQueue.main.async {
                       let isLoading = self?.viewModel.isLoading ?? false
                       if isLoading {
                           self?.activityIndicator.startAnimating()
                       }else {
                           self?.activityIndicator.stopAnimating()
                           self?.collectionView.reloadData()
                       }
                   }
               }
        viewModel.showError = { [weak self] () in
            DispatchQueue.main.async {
                if let errorMessage = self?.viewModel.errorMessage, errorMessage.count > 0  {
                    self?.showAlert(message: errorMessage)
                }
        }
        }
    }
    
    func search(keyWord: String) {
        viewModel.keyWord = keyWord

     }
    
    // MARK: UISearchBarDelegate
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let keyword = searchTextField.text {
        let keywordOptimized = viewModel.keywordAfterRemovingWhitespace(keyword: keyword)
            if keywordOptimized.count != 0 {
                search(keyWord: keywordOptimized)
            }
        }
    }
    
    // MARK: ShowAlert
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}


extension PhotoListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("number Of Cells == \(viewModel.numberOfCells)")
       return viewModel.numberOfCells
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView
           .dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath)
         cell.backgroundColor = .black

                return cell
    }
    
    
    
}

