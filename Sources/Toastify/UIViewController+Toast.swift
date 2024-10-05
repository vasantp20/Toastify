//
//  File.swift
//  
//
//  Created by Vasant on 05/10/24.
//

import Foundation
import UIKit

public extension UIViewController {
    func showSwiftToast(message: String, duration: Double = 2.0) {
        ToastManager.shared.showToast(message: message, duration: duration)
    }
}
