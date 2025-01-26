//
//  StateManagementPocApp.swift
//  StateManagementPoc
//
//  Created by Regis Kian on 1/26/25.
//

import SwiftUI

@main
struct MenuView: App {
    
    private let apiService = PostService()
    private let repository: PostRepository
    private let fetchUseCase: FetchPostsUseCase

    init() {
        repository = HttpPostRepository(apiService: apiService)
        fetchUseCase = FetchPostsUseCase(repository: repository)
    }

    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                List {
                    let concurrencyViewModel = ConcurrencyPostsViewModel(fetchPostsUseCase: fetchUseCase)
                    NavigationLink("1) SwiftUI + Concurrency") {
                        ConcurrencyPostsView(viewModel: concurrencyViewModel)
                    }
                    
                    let combinePostsViewModel = CombinePostsViewModel(fetchPostsUseCase: fetchUseCase)
                    NavigationLink("2) SwiftUI + Combine") {
                        CombinePostsView(viewModel: combinePostsViewModel)
                    }
                }
                .navigationTitle("Choose State Management")
            }
        }
    }
}
