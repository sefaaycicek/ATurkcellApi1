//
//  PostEntity.swift
//  ATurkcellApi1
//
//  Created by Sefa Aycicek on 2.10.2024.
//

import UIKit

struct PostResponse : Codable {
    let data : [Post]?
}

struct Post : Codable {
    let postId : Int
    let title : String?
    let body : String?
    
    enum CodingKeys : String, CodingKey {
        case postId = "id"
        case title, body
    }
}
