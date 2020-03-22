//
//  PhotoDetailViewModel.swift
//  ENBDAssignment
//
//  Created by Sharon on 22/03/2020.
//  Copyright © 2020 Sharon. All rights reserved.
//

import Foundation

class PhotoDetailViewModel {
    var photoDetail: PhotoDetail?
    init(model: PhotoDetail) {
        self.photoDetail = model
    }
    var imageURL: URL? {
        
        if let urlString = photoDetail?.largeImageURL {
            return URL(string: urlString)
        }
        return nil
    }
    var likes: String {
        
        return "\(photoDetail?.likes ?? 0) likes"
    }
    var comments: String {
       
        return "\(photoDetail?.comments ?? 0) comments"
    }
}
