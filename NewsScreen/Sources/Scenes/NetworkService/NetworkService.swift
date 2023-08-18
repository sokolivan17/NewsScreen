//
//  NetworkService.swift
//  NewsScreen
//
//  Created by Ваня Сокол on 16.08.2023.
//

import Foundation

// MARK: - Model
struct NetworkResponse: Codable {
    let articles: [Article]
}

struct Article: Codable {
    let source: Source
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String
}

struct Source: Codable {
    let name: String
}

// MARK: - NetworkService
final class NetworkService {
    static let shared = NetworkService()

    private init() {}

    public func getTopStories(completion: @escaping (Result<[Article], Error>) -> Void) {
        guard let url = NetworkServiceConstants.topHeadlinesURL else { return }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {

                do {
                    let result = try JSONDecoder().decode(NetworkResponse.self, from: data)

                    print("Articles: \(result.articles.count)")
                    DispatchQueue.main.async {
                        completion(.success(result.articles))
                    }
                } catch {
                    completion(.failure(error))
                }
            }
        }

        task.resume()
    }
}

// MARK: - Enums
enum NetworkServiceConstants {
    static let topHeadlinesURL = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=38f7df66943348baa716610ee92c049a")
}
