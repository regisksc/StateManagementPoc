//
//  DelegatePostsTableViewController.swift
//  StateManagementPoc
//
//  Created by Regis Kian on 1/26/25.
//


import UIKit

class DelegatePostsTableViewController: UITableViewController {
    private let fetchPostsUseCase: FetchPostsUseCase
    private var posts: [PostEntity] = []
    private var isLoading: Bool = false {
        didSet {
            if isLoading {
                let spinner = UIActivityIndicatorView(style: .medium)
                spinner.startAnimating()
                navigationItem.rightBarButtonItem = UIBarButtonItem(customView: spinner)
            } else {
                navigationItem.rightBarButtonItem = nil
            }
        }
    }
    private var errorMessage: String?

    init(fetchPostsUseCase: FetchPostsUseCase) {
        self.fetchPostsUseCase = fetchPostsUseCase
        super.init(style: .plain)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "UIKit + Delegates"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        fetchPosts()
    }

    private func fetchPosts() {
        // old-fashioned approach: do an async call, then a callback
        isLoading = true
        Task {
            do {
                let fetched = try await fetchPostsUseCase.execute()
                // Must run on main actor
                await MainActor.run {
                    posts = fetched
                    isLoading = false
                    tableView.reloadData()
                }
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    isLoading = false
                    showErrorAlert(errorMessage ?? "Unknown error")
                }
            }
        }
    }

    // MARK: - Table DataSource
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        posts.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath)
    -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let post = posts[indexPath.row]
        cell.textLabel?.text = post.title
        return cell
    }

    // MARK: - Helpers
    private func showErrorAlert(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
