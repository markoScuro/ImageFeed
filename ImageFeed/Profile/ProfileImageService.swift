//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Mark Balikoti on 19.08.2024.
//

import Foundation

final class ProfileImageService {
    
    // MARK: - Singleton ProfileImageService
    
    static let shared = ProfileImageService()
    private init(){}
    
    // MARK: - Public Properties
    
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    // MARK: - Private Properties
    
    private (set) var avatarURL: String?
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastUsername: String?
    
    // MARK: - Public Methods
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard lastUsername != username else {
            completion(.failure(ProfileServiceError.badRequest))
            print("Request did invalid")
            return
        }
        
        task?.cancel()
        lastUsername = username
        
        guard let request = makeProfileImageRequest(username: username) else {
            completion(.failure(ProfileServiceError.badURL))
            print("URL did not confirm")
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let userProfileResult):
                    guard let profileImageURL = userProfileResult.profileImage?.large else {
                        completion(.failure(ProfileServiceError.missingProfileImageURL))
                        print("Profile image did not downloaded")
                        return
                    }
                    self?.avatarURL = profileImageURL
                    completion(.success(profileImageURL))
                    
                    
                    NotificationCenter.default.post(
                        name: ProfileImageService.didChangeNotification,
                        object: self,
                        userInfo: ["URL": profileImageURL]
                    )
                    
                case .failure(let error):
                    if let networkError = error as? NetworkError {
                        self?.errorHandler(networkError)
                    } else {
                        print("Network error: \(error.localizedDescription)")
                    }
                    completion(.failure(error))
                    print("\(NSError().localizedDescription)")
                }
                self?.task = nil
                self?.lastUsername = nil
            }
        }
        self.task = task
        task.resume()
    }
    
    // MARK: - Private Methods
    
    private func makeProfileImageRequest(username: String) -> URLRequest? {
        guard let baseURL = URL(string: Constants.baseURL) else {
            assertionFailure("Failed to create URL")
            return nil
        }
        
        guard let url = URL(string: "/users/\(username)", relativeTo: baseURL) else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.addValue("Bearer \(String(describing: OAuth2TokenStorage.shared.bearerToken))", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        return request
    }
    
    private func errorHandler(_ networkError: NetworkError) {
        switch networkError {
        case .httpStatusCode(let statusCode):
            print("HTTP status code ERROR: \(statusCode)")
        case .badRequest:
            print("URl request ERROR: \(networkError.localizedDescription)")
        case .badSession:
            print("URL session ERROR: \(networkError.localizedDescription)")
        case .badURL:
            print("Invalid URL ERROR: \(networkError.localizedDescription) ")
        case .invalidJSON:
            print("InvalidJSON ERROR: \(networkError.localizedDescription)")
        }
    }
}






