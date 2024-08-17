//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Mark Balikoti on 31.07.2024.
//

import Foundation

final class OAuth2Service {
    
    // MARK: - Public Properties
    
    static let shared = OAuth2Service()
    weak var delegate: AuthViewControllerDelegate?
    
    // MARK: - Initializers
    
    private init() {}
    
    // MARK: - Private Properties
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String?
    
    // MARK: - Public Methods
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if task != nil {
            if lastCode != code {
                task?.cancel()
            } else {
                completion(.failure(NetworkError.urlRequestError))
                return
            }
        } else {
            if lastCode == code {
                completion(.failure(NetworkError.urlRequestError))
                return
            }
        }
        guard let request = make0AuthTokenRequest(with: code)
        else {
            completion(.failure(NetworkError.urlRequestError))
            print("Invalid fetch token request")
            return
        }
        
        let task = urlSession.dataTask(with: request) { [weak self]
            data, response, error in DispatchQueue.main.async {
                
                self?.task = nil
                self?.lastCode = nil
            }
        }
        self.task = task
        task.resume()
    }
    
    //        let task = URLSession.shared.data(for: request) { result in
    //            switch result {
    //            case .success(let data):
    //                let decoder = JSONDecoder()
    //                decoder.keyDecodingStrategy = .convertFromSnakeCase
    //                do {
    //                    let response = try decoder.decode(OAuthTokenResponseBody.self, from: data)
    //                    let tokenStorage = OAuth2TokenStorage()
    //                    tokenStorage.bearerToken = response.accessToken
    //                    completion(.success("\(response.accessToken)"))
    //                } catch {
    //                    print("Error decoding OAuthTokenResponseBody: \(error)")
    //                    completion(.failure(NetworkError.invalidJSON))
    //                }
    //            case .failure(let error):
    //                print("Network error occurred: \(error)")
    //                completion(.failure(error))
    //            }
    //        }
}
func make0AuthTokenRequest(with code: String) -> URLRequest? {
    
    var components = URLComponents(string: "https://unsplash.com/oauth/token")
    components?.queryItems = [
        URLQueryItem(name: "client_id", value: Constants.accessKey),
        URLQueryItem(name: "client_secret", value: Constants.secretKey),
        URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
        URLQueryItem(name: "code", value: code),
        URLQueryItem(name: "grant_type", value: "authorization_code")
    ]
    guard let url = components?.url else {
        assertionFailure("Failed to create URL")
        return nil
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    return request
    
}
