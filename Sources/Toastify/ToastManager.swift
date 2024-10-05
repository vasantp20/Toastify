//
//  File.swift
//  
//
//  Created by Vasant on 05/10/24.
//

import UIKit
import SwiftUI
public enum Position {
    case top
    case bottom
}

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
    
    // Method to show a toast with a custom view
    public func showToast<V: ToastViewProtocol>(toastView: V, duration: TimeInterval = 3.0, position: Position = .top, padding: CGFloat = 20) {
        guard let window = UIApplication.shared.windows.first else { return }
        
        // Create a UIHostingController to host the custom SwiftUI toast view
        let hostingController = UIHostingController(rootView: toastView)
        hostingController.view.backgroundColor = .clear
        
        // Add the hosting controller's view to the window
        window.addSubview(hostingController.view)
        
        // Set initial constraints and position
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        switch position {
        case .top:
            NSLayoutConstraint.activate([
                hostingController.view.leadingAnchor.constraint(equalTo: window.leadingAnchor, constant: padding),
                hostingController.view.trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: -padding),
                hostingController.view.topAnchor.constraint(equalTo: window.safeAreaLayoutGuide.topAnchor, constant: 20)
            ])
        case .bottom:
            NSLayoutConstraint.activate([
                hostingController.view.leadingAnchor.constraint(equalTo: window.leadingAnchor, constant: padding),
                hostingController.view.trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: -padding),
                hostingController.view.bottomAnchor.constraint(equalTo: window.bottomAnchor, constant: -100)
            ])
        }
        
        // Animate the toast view and remove it after the duration
        hostingController.view.alpha = 0
        UIView.animate(withDuration: 0.5, animations: {
            hostingController.view.alpha = 1
        }, completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                UIView.animate(withDuration: 0.5, animations: {
                    hostingController.view.alpha = 0
                }, completion: { _ in
                    hostingController.view.removeFromSuperview()
                })
            }
        })
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
