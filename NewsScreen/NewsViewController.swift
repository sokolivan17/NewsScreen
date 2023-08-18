//
//  NewsViewController.swift
//  NewsScreen
//
//  Created by Ваня Сокол on 16.08.2023.
//

import UIKit

class NewsViewController: UIViewController {

    // MARK: - Properties
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    private var articles = [Article]()
    private var viewModels = [NewsTableViewCellViewModel]()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupNavigationBar()
        setupHierarcy()
        setupLayout()
        fetchTopStories()
    }

    // MARK: - Setup
    private func setupNavigationBar() {
        title = "News"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func setupHierarcy() {
        view.addSubview(tableView)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension NewsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier,
                                                 for: indexPath) as? NewsTableViewCell else { fatalError() }
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return TableViewConstants.rowHeight
    }
}

// MARK: - Network
extension NewsViewController {
    private func fetchTopStories() {
        NetworkService.shared.getTopStories { [weak self] result in
            switch result {
            case .success(let articles):
                self?.articles = articles
                self?.viewModels = articles.compactMap({
                    NewsTableViewCellViewModel(title: $0.title,
                                               subtitle: $0.description ?? "Press on the news to see description",
                                               imageURL: URL(string: $0.urlToImage ?? ""))
                })

                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: - Enums
enum TableViewConstants {
    static let rowHeight: CGFloat = 150
}
