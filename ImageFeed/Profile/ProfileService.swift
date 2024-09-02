//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Mark Balikoti on 17.08.2024.
//

import Foundation

final class ProfileService {
    
    // MARK: - Singleton ProfileService
    
    static let shared = ProfileService()
    private init() { }
    
    // MARK: - Private Properties
    
    private let urlSession = URLSession.shared
    
    private var task: URLSessionTask?
    private(set) var profile: Profile?
    
    // MARK: - Public Methods
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        if task != nil {
            task?.cancel()
        }
        
        guard let request = makeProfileRequest(token: token) else {
            completion(.failure(NetworkError.badRequest))
            return
        }
        
        task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let profileResult):
                let profile = Profile(from: profileResult)
                self.profile = profile
                completion(.success(profile))
                print("Data did fetched")
            case .failure(let error):
                print("Description of ERROR - \(error.localizedDescription)")
                completion(.failure(error))
                print("Data did not fetched")
            }
        }
        task?.resume()
    }
    
    // MARK: - Private Methods
    
    private func makeProfileRequest(token: String) -> URLRequest? {
        guard let url = URL(string: "https://api.unsplash.com/me") else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
