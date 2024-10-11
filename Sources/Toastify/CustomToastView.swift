//
//  File.swift
//  
//
//  Created by Vasant on 10/10/24.
//

import Foundation
import SwiftUI

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
