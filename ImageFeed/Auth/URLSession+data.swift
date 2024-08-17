//
//  URLSession+data.swift
//  ImageFeed
//
//  Created by Mark Balikoti on 31.07.2024.
//

import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError
    case urlSessionError
    case invalidURL
    case invalidJSON
}

extension URLSession {
    func data(
        for request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let fulfillCompletionOnTheMainThread: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    fulfillCompletionOnTheMainThread(.success(data))
                } else {
                    fulfillCompletionOnTheMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if error != nil {
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlRequestError))
            } else {
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlSessionError))
            }
        })
        
        return task
    }
}

extension URLSession {
     func objectTask<T: Decodable>(
         for request: URLRequest,
         completion: @escaping (Result<T, Error>) -> Void
     ) -> URLSessionTask {
         let decoder = JSONDecoder()
         decoder.keyDecodingStrategy = .convertFromSnakeCase

         let task = data(for: request) { (result: Result<Data, Error>) in
             switch result {
             case .success(let data):
                 do {
                     let object = try decoder.decode(T.self, from: data)
                     completion(.success(object))
                 }
                 catch {
                     print("DEBUG",
                           "[\(String(describing: self)).\(#function)]:",
                           "Decoding error: \(error.localizedDescription)",
                           "data: \(String(data: data, encoding: .utf8) ?? "")",
                           separator: "\n")
                     completion(.failure(NetworkError.invalidJSON))
                 }
             case .failure(let error):
                 print("DEBUG",
                       "[\(String(describing: self)).\(#function)]:",
                       NetworkError.urlRequestError,
                       error.localizedDescription,
                       separator: "\n")
                 completion(.failure(error))
             }
         }
         return task
     }
 }
