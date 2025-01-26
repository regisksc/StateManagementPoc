//
//  RxSwiftPostsViewModel.swift
//  StateManagementPoc
//
//  Created by Regis Kian on 1/26/25.
//

import SwiftUI
import RxSwift

@MainActor
class RxSwiftPostsViewModel: ObservableObject, PostsViewModelProtocol {
    @Published var posts: [PostEntity] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let fetchPostsUseCase: FetchPostsUseCase
    private let disposeBag = DisposeBag()
    
    init(fetchPostsUseCase: FetchPostsUseCase) {
        self.fetchPostsUseCase = fetchPostsUseCase
    }
    
    func loadPosts() {
        isLoading = true
        errorMessage = nil
        
        let observable = Observable<[PostEntity]>.create { [weak self] observer in
            guard let self else {
                observer.onCompleted()
                return Disposables.create()
            }
            
            Task {
                do {
                    let fetched = try await self.fetchPostsUseCase.execute()
                    observer.onNext(fetched)
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
        
        observable
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] event in
                guard let self else { return }
                switch event {
                case .next(let posts):
                    self.posts = posts
                case .error(let error):
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                case .completed:
                    self.isLoading = false
                }
            }
            .disposed(by: disposeBag)
    }
}

