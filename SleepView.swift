//
//  SleepView.swift
//  HealthyCampus-Main-2
//
//  Created by Precious on 3/27/26.
//
import SwiftUI

struct SleepView: View {
    @Environment(\.dismiss) var dismiss
    @State private var isWindDownEnabled = false
    @State private var napTime: Double = 20
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 25) {
                
                // Header with Dismiss
                HStack {
                    Text("Sleep Lab 😴")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title).foregroundColor(.gray.opacity(0.3))
                    }
                }
                .padding(.horizontal).padding(.top)

                // 1. STATS CARD
                HStack(spacing: 15) {
                    SleepStatCard(title: "Avg Sleep", value: "7.2h", icon: "clock.fill", color: .blue)
                    SleepStatCard(title: "Deep Sleep", value: "85%", icon: "zap.fill", color: .purple)
                }
                .padding(.horizontal)

                // 2. WIND DOWN TOGGLE
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Wind Down Mode").font(.headline)
                            Text("Silence notifications 30m before bed").font(.subheadline).foregroundColor(.secondary)
                        }
                        Spacer()
                        Toggle("", isOn: $isWindDownEnabled).tint(.purple)
                    }
                    .padding().background(Color.white).cornerRadius(20)
                }
                .padding(.horizontal)

                // 3. POWER NAP TIMER
                VStack(alignment: .leading, spacing: 15) {
                    Text("QUICK RECHARGE").font(.caption.bold()).foregroundColor(.gray).tracking(1)
                    
                    VStack(spacing: 20) {
                        Text("\(Int(napTime)) min").font(.system(size: 40, weight: .bold, design: .rounded))
                        
                        Slider(value: $napTime, in: 10...45, step: 5)
                            .tint(.blue)
                        
                        Button(action: { /* Start Nap Timer */ }) {
                            Text("Start Power Nap")
                                .font(.headline).foregroundColor(.white)
                                .frame(maxWidth: .infinity).padding()
                                .background(Color.blue).cornerRadius(15)
                        }
                    }
                    .padding().background(Color.white).cornerRadius(20)
                }
                .padding(.horizontal)
            }
        }
        .background(Color(red: 0.98, green: 0.98, blue: 1.0).ignoresSafeArea())
    }
}

struct SleepStatCard: View {
    let title: String; let value: String; let icon: String; let color: Color
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: icon).foregroundColor(color)
            Text(value).font(.title2.bold())
            Text(title).font(.caption).foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding().background(Color.white).cornerRadius(20).shadow(color: .black.opacity(0.02), radius: 10)
    }
}
