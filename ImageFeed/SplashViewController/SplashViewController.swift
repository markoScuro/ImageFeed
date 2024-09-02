//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Mark Balikoti on 31.07.2024.
//

import UIKit

final class SplashViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private let oauth2Service = OAuth2Service.shared
    private let oauth2TokenStorage = OAuth2TokenStorage.shared
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    private lazy var splashViewImage: UIImageView = {
        let image = UIImage(named: "splash_logo_screen")
        let imageView = UIImageView(image: image)
        imageView.backgroundColor = UIColor.black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        return imageView
    }()
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSplashViewConstraints()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        switchToAuthPathOrTapBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNeedsStatusBarAppearanceUpdate()
    }
    
    // MARK: - Overrides Methods
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    // MARK: - Private Methods
    
    private func setupSplashViewConstraints() {
        NSLayoutConstraint.activate([
            splashViewImage.heightAnchor.constraint(equalToConstant: 75),
            splashViewImage.widthAnchor.constraint(equalToConstant: 75),
            splashViewImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            splashViewImage.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func switchToAuthPathOrTapBar() {
        if oauth2TokenStorage.bearerToken != nil {
            switchToTabBarController()
        } else {
            self.showAuthViewController()
        }
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            print("[window]: You configuration is incorrect")
            return
        }
        let tabBarController = UIStoryboard(
            name: "Main",
            bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
    
    private func showAuthViewController() {
        let storyboard = UIStoryboard(
            name: "Main",
            bundle: nil)
        guard let authViewController = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController else {
            print("Failed to instantiate AuthViewController")
            return
        }
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        present(authViewController, animated: true, completion: nil)
    }
    
    private func fetchOAuthToken(_ code: String) {
        UIBlockingProgressHUD.show()
        oauth2Service.fetchOAuthToken(code: code) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self = self else { return }
            switch result {
            case .success:
                
                print("Authorisation did success")
                
                profileImageService.fetchProfileImageURL(
                    username: profileService.profile?.username ?? "userName") {_ in }
                self.switchToTabBarController()
            case .failure (let error):
                print("Authorisation did had ERROR \(error.localizedDescription)")
                break
            }
        }
    }
}

// MARK: - AuthViewControllerDelegate

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchOAuthToken(code)
        }
    }
    
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
        switchToTabBarController()
    }
}


