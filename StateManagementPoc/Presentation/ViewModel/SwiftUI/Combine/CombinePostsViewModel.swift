//
//  CombinePostsViewModel.swift
//  StateManagementPoc
//
//  Created by Regis Kian on 1/26/25.
//

import SwiftUI
import Combine

@MainActor
class CombinePostsViewModel: ObservableObject, PostsViewModelProtocol {
    @Published var posts: [PostEntity] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let fetchPostsUseCase: FetchPostsUseCase
    private var cancellables = Set<AnyCancellable>()

    init(fetchPostsUseCase: FetchPostsUseCase) {
        self.fetchPostsUseCase = fetchPostsUseCase
    }

    func loadPosts() {
        isLoading = true
        errorMessage = nil

        // Bridge async use case to Combine's Future
        Future<[PostEntity], Error> { [weak self] promise in
            guard let self = self else { return }
            Task {
                do {
                    let entities = try await self.fetchPostsUseCase.execute()
                    promise(.success(entities))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .sink { [weak self] completion in
            guard let self = self else { return }
            self.isLoading = false
            if case let .failure(err) = completion {
                self.errorMessage = err.localizedDescription
            }
        } receiveValue: { [weak self] posts in
            self?.posts = posts
        }
        .store(in: &cancellables)
    }
}
