//
//  URLSession+data.swift
//  ImageFeed
//
//  Created by Mark Balikoti on 31.07.2024.
//

import Foundation

extension URLSession {
    func data(for request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionTask {
        
        let fulfillCompletionOnTheMainThread: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let data = data,
               let response = response,
               let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    fulfillCompletionOnTheMainThread(.success(data))
                } else {
                    fulfillCompletionOnTheMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
                    print("Status code ERROR - \(statusCode.description)")
                }
            } else if error != nil {
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlRequestError))
                print(NSError(domain: "URL request ERROR", code: 400))
            } else {
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlSessionError))
                print("Just URL Session ERROR")
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
        
        
        let task = data(for: request) { (result: Result<Data, Error>) in
            switch result {
            case .success(let data):
                do {
                    let decoder = SnakeCaseJSONDecoder()
                    let object = try decoder.decode(T.self, from: data)
                    completion(.success(object))
                }
                catch {
                    completion(.failure(NetworkError.invalidJSON))
                    print("Decoding JSON file ERROR")
                }
            case .failure(let unknownError):
                completion(.failure(unknownError))
                print("ERROR non authorized")
            }
        }
        return task
    }
}
