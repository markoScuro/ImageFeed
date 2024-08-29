//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Mark Balikoti on 31.07.2024.
//

import Foundation

final class OAuth2Service {
    
    // MARK: - SingleTon OAuth2Service
    
    static let shared = OAuth2Service()
    private init() {}
    
    // MARK: - Public Properties
    
    weak var delegate: AuthViewControllerDelegate?
    
    // MARK: - Private Properties
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String?
    
    // MARK: - Public Methods
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard lastCode != code else {
            completion(.failure(OAuthError.urlRequestError))
            print("URL request did not success")
            return
        }
        task?.cancel()
        lastCode = code

        guard let request = make0AuthTokenRequest(with: code)
        else {
            completion(.failure(OAuthError.urlRequestError))
            print("Invalid fetch token request")
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let oathToken):
                    OAuth2TokenStorage.shared.bearerToken = oathToken.accessToken
                    completion(.success(oathToken.accessToken))
                case .failure(let error):
                    if let oauthError = error as? OAuthError {
                        switch oauthError {
                        case .httpStatusCode(let statusCode):
                            print("HTTP status code error: \(statusCode.description)")
                        case .urlRequestError:
                            print("URL request error: \(error.localizedDescription))")
                        }
                    } else {
                        print("Unknown network error: \(error.localizedDescription)")
                    }
                    completion(.failure(error))
                }
                self?.task = nil
                self?.lastCode = nil
            }
        }
        self.task = task
        task.resume()
    }
    
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
