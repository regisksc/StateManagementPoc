//
//  PostsFeatureView.swift
//  StateManagementPoc
//
//  Created by Regis Kian on 1/26/25.
//


// Presentation/Shared/PostsFeatureView.swift
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
                }
            }
            .navigationTitle(title)
        }
        .onAppear {
            viewModel.loadPosts()
        }
    }
}
