//
//  PostEntity.swift
//  StateManagementPoc
//
//  Created by Regis Kian on 1/26/25.
//


struct PostEntity: Equatable, Identifiable {
    let id: Int
    let userID: Int
    let title: String
    let body: String
}