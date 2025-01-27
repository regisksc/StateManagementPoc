//
//  PostsTableViewController.swift
//  StateManagementPoc
//
//  Created by Regis Kian on 1/26/25.
//

import UIKit
import RxSwift

final class PostsTableViewController: UITableViewController {
    private let viewModel: UIKitRxPostsViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: UIKitRxPostsViewModel) {
        self.viewModel = viewModel
        super.init(style: .plain)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "UIKit + RxSwift"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        subscribeToViewModel()
        viewModel.loadPosts()
    }
    
    private func subscribeToViewModel() {
        viewModel.isLoadingSubject
            .subscribe { [weak self] loading in
                self?.updateLoading(loading)
            }.disposed(by: disposeBag)
        
        viewModel.errorSubject
            .compactMap { $0 }
            .subscribe (onNext: { [weak self] errorMessage in
                self?.showErrorAlert(errorMessage)
            })
            .disposed(by: disposeBag)
        
        viewModel.postsSubject
            .compactMap { $0 }
            .subscribe (onNext: { _ in
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    private func updateLoading(_ isLoading: Bool) {
        if isLoading {
            let spinner = UIActivityIndicatorView(style: .medium)
            spinner.startAnimating()
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: spinner)
        } else {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    private func showErrorAlert(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        (try? viewModel.postsSubject.value())?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if let posts = try? viewModel.postsSubject.value() {
            let post = posts[indexPath.row]
            cell.textLabel?.text = post.title
        }
        
        return cell
    }
}
