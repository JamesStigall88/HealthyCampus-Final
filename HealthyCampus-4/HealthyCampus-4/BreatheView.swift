//
//  BreatheView.swift
//  HealthyCampus-Main-2
//
//  Created by Precious on 3/25/26.
//

import SwiftUI

struct BreatheView: View {
    @Environment(\.dismiss) var dismiss
    @State private var isAnimating = false
    @State private var breatheText = "Ready?"
    @State private var timerCount = 0
    
    // Animation constants for a 4-second inhale/exhale cycle
    let animationDuration: Double = 4.0

    var body: some View {
        ZStack {
            // Background follows your app's theme
            Color(red: 0.98, green: 0.98, blue: 1.0).ignoresSafeArea()
            
            VStack(spacing: 60) {
                // 1. HEADER
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.title2.bold())
                            .foregroundColor(.purple)
                    }
                    Spacer()
                    Text("Breathe")
                        .font(.headline)
                        .foregroundColor(.gray)
                    Spacer()
                    // Empty space to balance the back button
                    Color.clear.frame(width: 40, height: 40)
                }
                .padding(.horizontal)

                // 2. MAIN BREATHING ICON (The "Lungs")
                VStack(spacing: 20) {
                    ZStack {
                        // Outer glowing rings
                        Circle()
                            .stroke(Color.orange.opacity(0.2), lineWidth: 2)
                            .frame(width: 220, height: 220)
                            .scaleEffect(isAnimating ? 1.2 : 0.8)
                        
                        Circle()
                            .stroke(Color.orange.opacity(0.1), lineWidth: 4)
                            .frame(width: 260, height: 260)
                            .scaleEffect(isAnimating ? 1.4 : 0.7)

                        // The Lung-style Icon
                        Image(systemName: "waveform.and.person.rectangle.rotated")
                            .font(.system(size: 80))
                            .foregroundColor(.orange)
                            .scaleEffect(isAnimating ? 1.1 : 0.9)
                    }
                    .animation(.easeInOut(duration: animationDuration).repeatForever(autoreverses: true), value: isAnimating)

                    Text(breatheText)
                        .font(.system(size: 28, weight: .medium, design: .rounded))
                        .foregroundColor(.purple)
                        .transition(.opacity)
                        .id(breatheText)
                }

                // 3. INSTRUCTION CARD
                VStack(spacing: 15) {
                    Text("Focus on your ribbon of breath.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Button(action: {
                        startBreathingSession()
                    }) {
                        Text(isAnimating ? "Stop Session" : "Start Session")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(width: 200, height: 50)
                            .background(isAnimating ? Color.gray : Color.purple)
                            .cornerRadius(25)
                            .shadow(color: .purple.opacity(0.3), radius: 10, y: 5)
                    }
                }
                
                Spacer()
            }
            .padding(.top)
        }
        .navigationBarBackButtonHidden(true)
    }

    // Logic to toggle the animation and text
    func startBreathingSession() {
        withAnimation {
            isAnimating.toggle()
        }
        
        if isAnimating {
            runTimer()
        } else {
            breatheText = "Ready?"
        }
    }

    func runTimer() {
        breatheText = "Inhale..."
        
        // Simple toggle for text based on the 4-second duration
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
            if isAnimating {
                breatheText = "Exhale..."
                DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
                    if isAnimating { runTimer() }
                }
            }
        }
    }
}
