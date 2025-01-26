//
//  PostRepository.swift
//  StateManagementPoc
//
//  Created by Regis Kian on 1/26/25.
//


import Foundation

protocol PostRepository {
    func fetchPosts() async throws -> [PostEntity]
}