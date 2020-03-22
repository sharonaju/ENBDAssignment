//
//  Photo.swift
//  ENBDAssignment
//
//  Created by Sharon on 22/03/2020.
//  Copyright © 2020 Sharon. All rights reserved.
//

import Foundation
struct Photo {
    let id: Int
    let previewURL: String?
    let likes: Int?
    let comments: Int?
    let largeImageURL: String?
    var tags = [String]()
    
}
extension Photo {
    
    init?(json: JSON) {
        guard let id = json["id"] as? Int else {
            return nil
        }
        
        self.id = id
        self.previewURL = json["previewURL"] as? String
        self.likes = json["likes"] as? Int
        self.comments = json["comments"] as? Int
        self.largeImageURL = json["largeImageURL"] as? String
        if let tags = json["tags"] as? [String]  {
            self.tags = tags
        }
    }
}
