//
//  CombinePostsView.swift
//  StateManagementPoc
//
//  Created by Regis Kian on 1/26/25.
//

import SwiftUI

struct CombinePostsView: View {
    @StateObject private var viewModel: CombinePostsViewModel
    
    init(viewModel: CombinePostsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                Text("... loading ...")
            } else if let error = viewModel.errorMessage {
                Text(error)
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
        .navigationTitle("SwiftUI + Combine")
        .task {
            viewModel.loadPosts()
        }
    }
}
