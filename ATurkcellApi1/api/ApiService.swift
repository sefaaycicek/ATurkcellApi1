//
//  ApiService.swift
//  ATurkcellApi1
//
//  Created by Sefa Aycicek on 2.10.2024.
//

import UIKit

class ApiService: ApiServiceProtocol {
    func fetchPosts() async throws -> [Post]? {
        let urlString = "https://jsonplaceholder.typicode.com/posts"
        guard let url = URL(string: urlString) else { return nil }
        
        let (data, urlResponse) = try await URLSession.shared.data(from: url)
        print(urlResponse)
        return try JSONDecoder().decode([Post].self, from: data)
    }
}

protocol ApiServiceProtocol {
    func fetchPosts() async throws -> [Post]?
}
