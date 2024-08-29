//
//  UIBlockingProgressHUD.swift
//  ImageFeed
//
//  Created by Mark Balikoti on 17.08.2024.
//

import UIKit
import ProgressHUD

class UIBlockingProgressHUD {
    
    // MARK: - Private Properties
    
    private static var window: UIWindow? {
        return UIApplication.shared.windows.first
    }
    
    // MARK: - Public Methods
    
    static func show() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.animate()
        ProgressHUD.animationType = .activityIndicator
        ProgressHUD.colorHUD = UIColor.gray
    }
    static func dismiss() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
}
