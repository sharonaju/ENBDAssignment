//
//  PhotoListViewModel.swift
//  ENBDAssignment
//
//  Created by Sharon on 22/03/2020.
//  Copyright © 2020 Sharon. All rights reserved.
//

import Foundation
class PhotoListViewModel {
    
    var isLoading: Bool = false {
        didSet {
            updateLoadingStatus?()
        }
    }
    
    var keyWord: String = "" {
        didSet {
            fetchData(loadMore: false)
        }
    }
    
    var errorMessage: String = "" {
        didSet {
            self.showError?()
        }
    }
    
    var page: Int = 0
    
    var updateLoadingStatus: (() -> Void)?
    
    var showError: (() -> Void)?
    
    var showEmptyData: (() -> Void)?
    
    var updatePaginationStatus: (() -> Void)?
    
     private var cellViewModels: [PhotoListCellViewModel] = [PhotoListCellViewModel]()
    
    func fetchData(loadMore: Bool) {
        isLoading = true
        APIService.shared.search(keyWord: keyWord, loadMore: loadMore) { (photos, error) in
            if let searchResults = photos {
                if loadMore {
                    self.cellViewModels.append(contentsOf: self.createCellViewModel(images: searchResults))
                } else {
                   self.cellViewModels = self.createCellViewModel(images: searchResults)
                }
                
            } else {
                self.errorMessage = error?.errorDescription ?? ""
            }
            self.isLoading = false

        }
        
    }

    func createCellViewModel(images: [Photo]) -> [PhotoListCellViewModel] {
        var cellViewModels = [PhotoListCellViewModel]()
        for item in images {
            if let previewURL = item.previewURL, let bigImageURL = item.largeImageURL, let likesCount = item.likes, let comments = item.comments {
                let tags: [String] = item.tags?.components(separatedBy: ",") ?? []
                let tagsCustomized = tags.map{$0.capitalized}
                let firstThreeTags = Array(tagsCustomized.prefix(3)) // To get the maximum 3 tags
                let tagString = firstThreeTags.joined(separator: ",")
                let cellViewModel = PhotoListCellViewModel(previewURL: previewURL, bigImageURL: bigImageURL, likes: likesCount, comments: comments, tags: tagString)
                cellViewModels.append(cellViewModel)
            }
        }
        return cellViewModels
        
    }
    
    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> PhotoListCellViewModel {
        return cellViewModels[indexPath.row]
    }
    
    func keywordAfterRemovingWhitespace(keyword: String) -> String {
        return keyword.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func getPhotoDetail(at indexPath: IndexPath) -> PhotoDetail {
        
        let photo = cellViewModels[indexPath.row]
        return PhotoDetail(largeImageURL: photo.bigImageURL, likes: photo.likes, comments: photo.comments)
    }
}

struct PhotoListCellViewModel {
    let previewURL: String
    let bigImageURL: String
    let likes: Int
    let comments: Int
    let tags: String
}
