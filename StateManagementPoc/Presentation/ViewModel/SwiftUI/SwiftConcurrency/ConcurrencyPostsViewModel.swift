//
//  ConcurrencyPostsViewModel.swift
//  StateManagementPoc
//
//  Created by Regis Kian on 1/26/25.
//

import SwiftUI

@MainActor
class ConcurrencyPostsViewModel: ObservableObject, PostsViewModelProtocol {
    @Published var posts: [PostEntity] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let fetchPostsUseCase: FetchPostsUseCase
    
    init(fetchPostsUseCase: FetchPostsUseCase) {
        self.fetchPostsUseCase = fetchPostsUseCase
    }
    
    func loadPosts() {
        Task {
            isLoading = true
            errorMessage = nil
            
            do {
                posts = try await fetchPostsUseCase.execute()
            } catch {
                errorMessage = error.localizedDescription
            }
            
            isLoading = false
        }
    }
}
