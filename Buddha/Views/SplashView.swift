//
//  SplashView.swift
//  Buddha
//
//  Created by Weijia Huang on 12/14/25.
//

import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    var body: some View {
        if isActive {
            MainTabView()
        } else {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [
                        Color(red: 0.85, green: 0.80, blue: 0.95),
                        Color(red: 0.75, green: 0.70, blue: 0.90)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    // Buddhist symbol or icon
                    ZStack {
                        // Outer circle with gradient
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.65, green: 0.50, blue: 0.85),
                                        Color(red: 0.55, green: 0.40, blue: 0.75)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 140, height: 140)
                            .shadow(color: Color.purple.opacity(0.3), radius: 25, x: 0, y: 12)
                        
                        // Inner circle
                        Circle()
                            .fill(Color.white.opacity(0.3))
                            .frame(width: 100, height: 100)
                        
                        // Dharma wheel or lotus symbol
                        ZStack {
                            // Eight-spoked wheel
                            ForEach(0..<8) { index in
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(Color.white)
                                    .frame(width: 4, height: 35)
                                    .offset(y: -20)
                                    .rotationEffect(.degrees(Double(index) * 45))
                            }
                            
                            // Center circle
                            Circle()
                                .fill(Color.white)
                                .frame(width: 20, height: 20)
                        }
                    }
                    .scaleEffect(size)
                    .opacity(opacity)
                    
                    // App name
                    Text("Buddha")
                        .font(.system(size: 42, weight: .light, design: .serif))
                        .foregroundColor(Color(red: 0.35, green: 0.20, blue: 0.50))
                        .opacity(opacity)
                    
                    // Subtitle
                    Text("Wisdom for Daily Life")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(Color(red: 0.50, green: 0.35, blue: 0.65))
                        .opacity(opacity)
                }
            }
            .onAppear {
                withAnimation(.easeIn(duration: 1.2)) {
                    self.size = 1.0
                    self.opacity = 1.0
                }
                
                // Transition to main view after delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

