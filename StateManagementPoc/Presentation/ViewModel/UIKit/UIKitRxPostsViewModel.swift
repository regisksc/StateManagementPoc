//
//  UIKitRxPostsViewModel.swift
//  StateManagementPoc
//
//  Created by Regis Kian on 1/26/25.
//

import RxSwift
import RxCocoa

final class UIKitRxPostsViewModel {
    private let fetchPostsUseCase: FetchPostsUseCase
    private let disposeBag = DisposeBag()

    let postsSubject = BehaviorSubject<[PostEntity]>(value: [])
    let errorSubject = PublishSubject<String?>()
    let isLoadingSubject = BehaviorSubject<Bool>(value: false)

    init(fetchPostsUseCase: FetchPostsUseCase) {
        self.fetchPostsUseCase = fetchPostsUseCase
    }
    
    private func fetchTask(_ observer: AnyObserver<[PostEntity]>) {
        Task {
            do {
                let entities = try await self.fetchPostsUseCase.execute()
                observer.onNext(entities)
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
        }
    }
    
    func loadPosts() {
        isLoadingSubject.onNext(true)
        errorSubject.onNext(nil)
        
        let observable = Observable<[PostEntity]>.create { [weak self] observer in
            guard let self else {
                observer.onCompleted()
                return Disposables.create()
            }
            
            fetchTask(observer)
            
            return Disposables.create()
        }
        
        observable
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] event in
                guard let self else { return }
                switch event {
                    case .next(let data):
                        self.postsSubject.onNext(data)
                case .error(let error):
                    self.errorSubject.onNext(error.localizedDescription)
                    self.isLoadingSubject.onNext(false)
                case .completed:
                    self.isLoadingSubject.onNext(false)
                }
            }
            .disposed(by: disposeBag)
    }
}
