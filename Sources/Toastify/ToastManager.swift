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
    private let operationQueue = OperationQueue()

    private init() {
        operationQueue.maxConcurrentOperationCount = 1
    }

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
       let operation = ShowToastOperation(toastView: toastView, duration: duration, position: position, padding: padding)
        self.operationQueue.addOperations([operation], waitUntilFinished: false)
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

class ShowToastOperation: Operation {
    
    private let hostingController: UIViewController
    private let duration: TimeInterval
    private let position: Position
    private let padding: CGFloat
    private var topConstraint: NSLayoutConstraint?
    
    override var isAsynchronous: Bool {
        return true
    }
    
    private var _isExecuting: Bool = false {
        willSet {
            willChangeValue(forKey: "isExecuting")
        }
        didSet {
            didChangeValue(forKey: "isExecuting")
        }
    }
    private var _isFinished: Bool = false {
        willSet {
            willChangeValue(forKey: "isFinished")
        }
        didSet {
            didChangeValue(forKey: "isFinished")
        }
    }
    
    init<V: ToastViewProtocol>(toastView: V, duration: TimeInterval = 3.0, position: Position = .top, padding: CGFloat = 20) {
        let hostingController = UIHostingController(rootView: toastView)
        self.hostingController = hostingController
        self.duration = duration
        self.position = position
        self.padding = padding
        
    }
    
    override var isExecuting: Bool {
            return _isExecuting
    }
    
    override var isFinished: Bool {
            return _isFinished
    }
    
    override func main() {

        if _isFinished { return }
        _isExecuting = true
        
       
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.first else { return }

            self.hostingController.view.backgroundColor = .clear

            // Add the hosting controller's view to the window

            window.addSubview(self.hostingController.view)
            
            // Set up swipe gesture recognizer
            let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(_:)))
            self.hostingController.view.addGestureRecognizer(swipeGesture)
            
            // Set initial constraints and position
            self.hostingController.view.translatesAutoresizingMaskIntoConstraints = false
            switch self.position {
            case .top:
                self.topConstraint = self.hostingController.view.topAnchor.constraint(equalTo: window.safeAreaLayoutGuide.topAnchor, constant: 24)
                NSLayoutConstraint.activate([
                    self.hostingController.view.leadingAnchor.constraint(equalTo: window.leadingAnchor, constant: self.padding),
                    self.hostingController.view.trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: -self.padding),
                    self.topConstraint!
                ])
            case .bottom:
                NSLayoutConstraint.activate([
                    self.hostingController.view.leadingAnchor.constraint(equalTo: window.leadingAnchor, constant: self.padding),
                    self.hostingController.view.trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: -self.padding),
                    self.hostingController.view.bottomAnchor.constraint(equalTo: window.bottomAnchor, constant: -100)
                ])
            }


            // Animate the toast view and remove it after the duration
            self.hostingController.view.alpha = 0
            UIView.animate(withDuration: 0.5, animations: { [weak self] in
                self?.hostingController.view.alpha = 1
            }, completion: { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + self.duration) { [weak self] in
                    UIView.animate(withDuration: 0.5, animations: {
                        self?.hostingController.view.alpha = 0
                    }, completion: { _ in
                        guard let self = self else { return }
                        self.hostingController.view.removeFromSuperview()
                        self.finishOperation()
                        
                    })
                }
            })
        }
    }
    
    // Handle swipe-up gesture
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.hostingController.view)

        // Check if the user has swiped up (negative Y translation)
        if gesture.state == .ended && translation.y < 0 {
            dismissToastWithSlide()
        }
    }
    
    // Helper to dismiss the toast with slide-up animation
    private func dismissToastWithSlide() {
        guard let view = self.hostingController.view else { return }

        UIView.animate(withDuration: 1, animations: {
            // Move the toast view off-screen (slide up)
            self.topConstraint?.constant = -view.frame.height-100
        }, completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                view.removeFromSuperview()
                self.finishOperation()
            }
        })
    }
    
    // Helper to dismiss the toast and mark the operation as finished
    private func dismissToast() {
        UIView.animate(withDuration: 0.5, animations: {
            self.hostingController.view.alpha = 0
        }, completion: { _ in
            self.hostingController.view.removeFromSuperview()
            self.finishOperation()
        })
    }
    
    // Helper to mark the operation as complete
    private func finishOperation() {
        _isExecuting = false
        _isFinished = true
    }
}



public struct CustomToastView: ToastViewProtocol {
    let title: String
    let message: String
    
    public init(title: String, message: String) {
        self.title = title
        self.message = message
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .padding([.top], 12)
                .foregroundColor(.white)
                .font(.headline)
                

            Text(message)
                .padding([.top, .bottom], 4)
                .foregroundColor(.white)
                .font(.subheadline)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.blue)
        .cornerRadius(20)
        .shadow(radius: 10)
        .padding(.horizontal, 4)
    }
}
