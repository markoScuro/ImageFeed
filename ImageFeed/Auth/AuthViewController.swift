//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Mark Balikoti on 27.07.2024.
//

import UIKit
import ProgressHUD

final class AuthViewController: UIViewController {
    
    // MARK: - Public Properties
    
    weak var delegate: AuthViewControllerDelegate?
    
    // MARK: - Private Properties
    
    private enum Identifiers {
        static let showWebViewSegueIdentifier = "ShowWebView"
        static let tapBarViewControllerID = "TabBarViewController"
    }
   
    private let tokenStorage = OAuth2TokenStorage.shared
    private let OAuthService = OAuth2Service.shared
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Overrides Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Identifiers.showWebViewSegueIdentifier {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else { fatalError("Failed to prepare for \(Identifiers.showWebViewSegueIdentifier)") }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    // MARK: - Private Methods
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: Identifiers.tapBarViewControllerID)
        
        window.rootViewController = tabBarController
    }
}

// MARK: - WebViewViewControllerDelegate

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        navigationController?.popViewController(animated: true)
        ProgressHUD.animate()
        ProgressHUD.animationType = .circleBarSpinFade
        ProgressHUD.colorHUD = UIColor.blue
        
        OAuthService.fetchOAuthToken(code: code) { [weak self] result in
            guard let self = self else { return }
            ProgressHUD.dismiss()
            
            switch result {
            case .success(let token):
                print(token)
                delegate?.authViewController(self, didAuthenticateWithCode: code)
                self.switchToTabBarController()
            case .failure(let error):
                print("Error fetching token: \(error)")
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
