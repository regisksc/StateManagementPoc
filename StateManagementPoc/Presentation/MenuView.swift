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
                    let concurrencyTitle = "SwiftUI + Concurrency"
                    NavigationLink(concurrencyTitle) {
                        PostsFeatureView(
                            title: concurrencyTitle,
                            viewModel: concurrencyViewModel
                        )
                    }
                    
                    let combinePostsViewModel = CombinePostsViewModel(fetchPostsUseCase: fetchUseCase)
                    let combineTitle = "SwiftUI + Combine"
                    NavigationLink(combineTitle) {
                        PostsFeatureView(
                            title: combineTitle,
                            viewModel: combinePostsViewModel
                        )
                    }
                    
                    let rxVM = RxSwiftPostsViewModel(fetchPostsUseCase: fetchUseCase)
                    let rxTitle = "SwiftUI + RxSwift"
                    NavigationLink(rxTitle) {
                        PostsFeatureView(
                            title: rxTitle,
                            viewModel: rxVM
                        )
                    }
                    
                    NavigationLink("UIKit + RxSwift") {
                        UIKitRxContainer(fetchPostsUsecase: fetchUseCase)
                    }
                }
                .navigationTitle("Choose State Management approach")
            }
        }
    }
}
