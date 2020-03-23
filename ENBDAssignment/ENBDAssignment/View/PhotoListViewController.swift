//
//  ViewController.swift
//  ENBDAssignment
//
//  Created by Sharon on 22/03/2020.
//  Copyright © 2020 Sharon. All rights reserved.
//

import UIKit
import SDWebImage

class PhotoListViewController: UIViewController, UISearchBarDelegate {
    
    // MARK: Properties

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadMoreActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchTextField: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    var viewModel: PhotoListViewModel = PhotoListViewModel()
    var isLoadMore = false
    
    // MARK:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchTextField.text = "Apple"
        prepareCollectionView()
        prepareUI()
        hideKeyboardWhenTappedAround()
        search(keyWord: searchTextField.text ?? "")
    }
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(resignTextField))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func resignTextField() {
        searchTextField.resignFirstResponder()
    }
    
    // MARK: Prepare UI

    func prepareUI() {
        searchTextField.resignFirstResponder()
        prepareUIForLoading()
        prepareUIForErrorHandling()
    }
    
    func prepareUIForLoading() {
        viewModel.updateLoadingStatus = { [weak self] () in
                          DispatchQueue.main.async {
                              let isLoading = self?.viewModel.isLoading ?? false
                              if isLoading {
                                if self?.isLoadMore == true {
                                    self?.loadMoreActivityIndicator.startAnimating()
                                    self?.isLoadMore = false

                                } else {
                                    self?.collectionView.alpha = 0
                                    self?.activityIndicator.startAnimating()
                                }
                                
                              }else {
                                self?.collectionView.alpha = 1
                                  self?.activityIndicator.stopAnimating()
                                self?.loadMoreActivityIndicator.stopAnimating()
                                  self?.collectionView.reloadData()
                              }
                          }
                      }
    }
    
    func prepareUIForErrorHandling() {
        viewModel.showError = { [weak self] () in
            DispatchQueue.main.async {
                if let errorMessage = self?.viewModel.errorMessage, errorMessage.count > 0  {
                    self?.showAlert(message: errorMessage)
                }
        }
        }
    }
    func prepareCollectionView() {
        collectionView.register(UINib(nibName: "PhotoCell", bundle: .main), forCellWithReuseIdentifier: "PhotoCell")
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 150, height: 150)
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 14
        collectionView.collectionViewLayout = layout
    }
    
    func search(keyWord: String) {
        viewModel.keyWord = keyWord

     }
    
    // MARK: UISearchBarDelegate
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchTextField.resignFirstResponder()
        if let keyword = searchTextField.text {
        let keywordOptimized = viewModel.keywordAfterRemovingWhitespace(keyword: keyword)
            if keywordOptimized.count != 0 {
                search(keyWord: keywordOptimized)
            }
        }
    }
    
    // MARK: ShowAlert
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}


extension PhotoListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return viewModel.numberOfCells
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView
           .dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        let photo = viewModel.getCellViewModel(at: indexPath)
        cell.imageView?.sd_setImage(with: URL(string: photo.previewURL), completed: nil)
        cell.tagsLabel.text = "Tags: \(photo.tags)"
        return cell
    }
    
     // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photoDetail = viewModel.getPhotoDetail(at: indexPath)
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = storyBoard.instantiateViewController(withIdentifier: "PhotoDetailViewController") as! PhotoDetailViewController
        detailVC.viewModel = PhotoDetailViewModel(model: photoDetail)
        self.navigationController?.pushViewController(detailVC, animated: true)
      
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row >= viewModel.numberOfCells - 1 {
            self.isLoadMore = true
            viewModel.fetchData(loadMore: true)
        }
    }

}

