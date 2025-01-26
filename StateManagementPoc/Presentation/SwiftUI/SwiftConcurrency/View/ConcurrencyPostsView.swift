//
//  ConcurrencyPostsView.swift
//  StateManagementPoc
//
//  Created by Regis Kian on 1/26/25.
//

import SwiftUI

struct ConcurrencyPostsView: View {
    @StateObject private var viewModel: ConcurrencyPostsViewModel
    
    init(viewModel: ConcurrencyPostsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("... loading ...")
            } else if let error = viewModel.errorMessage {
                Text("Error occurred: \(error)")
            } else {
                List(viewModel.posts) { post in
                    VStack(alignment: .leading) {
                        Text(post.title)
                            .bold()
                        
                        Text(post.body)
                            .font(.subheadline)
                    }
                }
            }
        }
        .navigationTitle("SwiftUI + Concurrency")
        .task {
            await viewModel.loadPosts()
        }
    }
}
