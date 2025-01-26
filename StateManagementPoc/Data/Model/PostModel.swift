//
//  PostModel.swift
//  StateManagementPoc
//
//  Created by Regis Kian on 1/26/25.
//

struct PostModel: Decodable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
    
    func mapToEntity() -> PostEntity {
        PostEntity(
            id: id,
            userID: userId,
            title: title,
            body: body
        )
    }
}
