//
//  FetchPostsUseCase.swift
//  StateManagementPoc
//
//  Created by Regis Kian on 1/26/25.
//


// Domain/UseCases/FetchPostsUseCase.swift
import Foundation

struct FetchPostsUseCase {
    private let repository: PostRepository

    init(repository: PostRepository) {
        self.repository = repository
    }

    func execute() async throws -> [PostEntity] {
        return try await repository.fetchPosts()
    }
}
