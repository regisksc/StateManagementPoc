//
//  PostsViewModelProtocol.swift
//  StateManagementPoc
//
//  Created by Regis Kian on 1/26/25.
//


// Presentation/Shared/PostsViewModelProtocol.swift
import Foundation

@MainActor
protocol PostsViewModelProtocol: ObservableObject {
    var posts: [PostEntity] { get set }
    var isLoading: Bool { get set }
    var errorMessage: String? { get set }

    func loadPosts()
}
