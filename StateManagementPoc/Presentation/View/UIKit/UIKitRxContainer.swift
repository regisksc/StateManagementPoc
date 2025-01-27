//
//  UIKitRxContainer.swift
//  StateManagementPoc
//
//  Created by Regis Kian on 1/26/25.
//

import SwiftUI

struct UIKitRxContainer: UIViewControllerRepresentable {
    let fetchPostsUsecase: FetchPostsUseCase
    
    func makeUIViewController(context: Context) -> PostsTableViewController {
        let viewModel = UIKitRxPostsViewModel(fetchPostsUseCase: fetchPostsUsecase)
        return PostsTableViewController(viewModel: viewModel)
    }
    
    func updateUIViewController(_ uiViewController: PostsTableViewController, context: Context) {
        // intentionally unimplemented
    }
}
