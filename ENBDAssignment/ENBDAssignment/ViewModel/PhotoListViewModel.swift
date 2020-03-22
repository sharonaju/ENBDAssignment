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
            self.updateLoadingStatus?()
        }
    }
    
    var keyWord: String = "" {
        didSet {
            fetchData()
        }
    }
    
    var errorMessage: String = "" {
        didSet {
            self.showError?()
        }
    }
    
    var updateLoadingStatus: (() -> Void)?
    var showError: (() -> Void)?

    
     private var cellViewModels: [PhotoListCellViewModel] = [PhotoListCellViewModel]()
    
    func fetchData() {
        isLoading = true
        APIService.shared.search(keyWord: keyWord) { (photos, error) in
            self.isLoading = false
            if let searchResults = photos {
                self.cellViewModels = self.createCellViewModel(images: searchResults)
            } else {
                self.errorMessage = error?.errorDescription ?? ""
            }
            
        }
        
    }

    func createCellViewModel(images: [Photo]) -> [PhotoListCellViewModel] {
        var cellViewModels = [PhotoListCellViewModel]()
        for item in images {
            if let previewURL = item.previewURL {
                let cellViewModel = PhotoListCellViewModel(imageURL: previewURL, tags: item.tags)
                cellViewModels.append(cellViewModel)
            }
        }
        return cellViewModels
        
    }
    
    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    func keywordAfterRemovingWhitespace(keyword: String) -> String {
        return keyword.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

struct PhotoListCellViewModel {
    let imageURL: String
    let tags: [String]
}
