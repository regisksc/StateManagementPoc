//
//  HttpPostRepository.swift
//  StateManagementPoc
//
//  Created by Regis Kian on 1/26/25.
//

import Foundation

struct HttpPostRepository: PostRepository {
    private let apiService: PostService

    init(apiService: PostService = PostService()) {
        self.apiService = apiService
    }

    func fetchPosts() async throws -> [PostEntity] {
        let dtos = try await apiService.fetchPosts()
        return dtos.map { $0.mapToEntity() }
    }
}
