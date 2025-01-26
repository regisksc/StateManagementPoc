//
//  PostService.swift
//  StateManagementPoc
//
//  Created by Regis Kian on 1/26/25.
//

import Foundation

protocol PostServiceProtocol {
    func fetchPosts() async throws -> [PostModel]
}

struct PostService: PostServiceProtocol {
    func fetchPosts() async throws -> [PostModel] {
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode([PostModel].self, from: data)
    }
}

