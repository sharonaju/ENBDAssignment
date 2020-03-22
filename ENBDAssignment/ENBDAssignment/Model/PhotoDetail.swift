//
//  PhotoDetail.swift
//  ENBDAssignment
//
//  Created by Sharon on 22/03/2020.
//  Copyright © 2020 Sharon. All rights reserved.
//

import Foundation
struct PhotoDetail {
    var largeImageURL: String?
    var likes: Int?
    var comments: Int?
}
extension PhotoDetail {
    init(photo: Photo) {
        self.largeImageURL = photo.largeImageURL
        self.likes = photo.likes
        self.comments = photo.comments
    }
}
