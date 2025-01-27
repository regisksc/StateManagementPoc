//
//  PostsFeatureView.swift
//  StateManagementPoc
//
//  Created by Regis Kian on 1/26/25.
//

import SwiftUI

struct PostsFeatureView<VM: PostsViewModelProtocol>: View {
    @StateObject private var viewModel: VM

    private let title: String

    init(title: String, viewModel: VM) {
        self.title = title
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                }
                else if let error = viewModel.errorMessage {
                    VStack(spacing: 16) {
                        Text("Error: \(error)")
                            .multilineTextAlignment(.center)
                        Button("Retry") {
                            viewModel.loadPosts()
                        }
                    }
                    .padding()
                }
                else {
                    List(viewModel.posts) { post in
                        VStack(alignment: .leading) {
                            Text(post.title).bold()
                            Text(post.body).font(.subheadline)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.loadPosts()
                    }) {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.loadPosts()
        }
    }
}
