//
//  PostListUIModel.swift
//  ATurkcellApi1
//
//  Created by Sefa Aycicek on 2.10.2024.
//

import UIKit

struct PostListUIModel {
    let postId : Int
    let title : String?
    let body : String?
    
    init(post: Post) {
        self.postId = post.postId
        self.title = post.title
        self.body = post.body
    }
}
