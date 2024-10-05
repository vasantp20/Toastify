//
//  File.swift
//  
//
//  Created by Vasant on 05/10/24.
//

import Foundation
import SwiftUI

public struct ToastView: View {
    public var message: String
    public var backgroundColor: Color
    public var textColor: Color
    public var cornerRadius: CGFloat

    public init(message: String,
                backgroundColor: Color = Color.black.opacity(0.8),
                textColor: Color = .white,
                cornerRadius: CGFloat = 10) {
        self.message = message
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.cornerRadius = cornerRadius
    }

    public var body: some View {
        Text(message)
            .foregroundColor(textColor)
            .padding()
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            .padding(.horizontal, 40)
            .shadow(radius: 5)
    }
}
