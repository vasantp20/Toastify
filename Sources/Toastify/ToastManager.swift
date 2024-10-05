//
//  File.swift
//  
//
//  Created by Vasant on 05/10/24.
//

import UIKit
import SwiftUI

public class ToastManager {
    public static let shared = ToastManager()
    
    private var toastController: UIViewController?

    private init() {}

    public func showToast(message: String, duration: Double = 2.0) {
        guard let window = UIApplication.shared.windows.first else { return }
        
        // Remove existing toast if any
        if let existingToast = toastController {
            existingToast.view.removeFromSuperview()
            existingToast.removeFromParent()
        }

        let toastView = ToastView(message: message)
        let toastHostingController = UIHostingController(rootView: toastView)
        toastHostingController.view.backgroundColor = .clear
        toastHostingController.view.alpha = 0 // Start invisible for fade-in animation

        // Add toast to the root window
        window.addSubview(toastHostingController.view)
        toastController = toastHostingController

        // Add Constraints
        toastHostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toastHostingController.view.bottomAnchor.constraint(equalTo: window.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            toastHostingController.view.centerXAnchor.constraint(equalTo: window.centerXAnchor)
        ])

        // Animate Toast In and Out
        UIView.animate(withDuration: 0.5, animations: {
            toastHostingController.view.alpha = 1 // Fade-in
        }) { (_) in
            UIView.animate(withDuration: 0.5, delay: duration, options: [], animations: {
                toastHostingController.view.alpha = 0 // Fade-out
            }) { (_) in
                toastHostingController.view.removeFromSuperview()
                toastHostingController.removeFromParent()
                self.toastController = nil
            }
        }
    }

    public func hideToast() {
        // Hide and remove toast
        if let toast = toastController {
            UIView.animate(withDuration: 0.5, animations: {
                toast.view.alpha = 0
            }) { (_) in
                toast.view.removeFromSuperview()
                toast.removeFromParent()
                self.toastController = nil
            }
        }
    }
}
