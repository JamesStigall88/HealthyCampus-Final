//
//  MainView.swift
//  HealthyCampus-Demo
//
//  Created by Admin on 2/10/26.
//
import SwiftUI

struct MainView: View {
    // MARK: - 1. PROPERTIES
    @AppStorage("isDarkMode") private var isDarkMode = false
    @State private var showSettings = false
    @State private var selectedTab = 0 // 0: Home, 1: Calm, 2: Connect, 3: AI
    
    let spotifyURL = URL(string: "https://open.spotify.com/")!
    
    var backgroundColor: Color {
        isDarkMode ? Color(red: 0.05, green: 0.07, blue: 0.12) : Color(red: 0.98, green: 0.98, blue: 1.0)
    }
    
    var cardColor: Color {
        isDarkMode ? Color(red: 0.12, green: 0.15, blue: 0.22) : .white
    }
    
    var primaryTextColor: Color {
        isDarkMode ? .white : Color(red: 0.1, green: 0.2, blue: 0.4)
    }
    
    // MARK: - 2. THE VIEW BODY
    var body: some View {
        NavigationStack {
            ZStack {
                backgroundColor.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // SWITCHER LOGIC
                    if selectedTab == 0 {
                        homeDashboard
                    } else if selectedTab == 1 {
                        CalmView()
                    } else if selectedTab == 2 {
                        ConnectView()
                    } else if selectedTab == 3 {
                        ChatView()
                    }
                    
                    Spacer(minLength: 0)
                    
                    bottomTabBar
                }
            }
            .preferredColorScheme(isDarkMode ? .dark : .light)
            .sheet(isPresented: $showSettings) {
                settingsSheet
            }
        }
    }
    
    // MARK: - HOME DASHBOARD
    private var homeDashboard: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 25) {
                headerSection
                
                NavigationLink(destination: SleepView()) {
                    sleepScheduleCard
                }
                .buttonStyle(PlainButtonStyle())
                
                wellnessSpacesSection
                
                // Native AI Section
                NavigationLink(destination: ChatView()) {
                    aiCompanionSectionContent
                }
                .buttonStyle(PlainButtonStyle())
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("WEEKLY SUMMARY").font(.caption.bold()).foregroundColor(.gray).tracking(1)
                    stressSummaryChart
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 20)
        }
    }

    // MARK: - UI SUB-SECTIONS
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text("Good evening,").font(.system(size: 18)).foregroundColor(.gray)
                Text("Bulldog 🌙").font(.system(size: 32, weight: .bold)).foregroundColor(primaryTextColor)
            }
            Spacer()
            Button(action: { showSettings = true }) {
                Image(systemName: "gearshape.fill")
                    .font(.title2).foregroundColor(.gray).padding(10)
                    .background(Circle().fill(cardColor))
            }
        }
        .padding(.horizontal).padding(.top, 20)
    }

    private var wellnessSpacesSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("WELLNESS SPACES").font(.caption.bold()).foregroundColor(.gray).tracking(1)
            HStack(spacing: 20) {
                NavigationLink(destination: SleepView()) { WellnessCircle(icon: "moon.fill", label: "Sleep", color: .yellow) }
                NavigationLink(destination: BreatheView()) { WellnessCircle(icon: "waveform.and.person.rectangle.rotated", label: "Breathe", color: .orange) }
                NavigationLink(destination: ExerciseView()) { WellnessCircle(icon: "figure.run", label: "Exercise", color: .blue) }
                NavigationLink(destination: StressorLogView()) { WellnessCircle(icon: "book.closed.fill", label: "Journal", color: .purple) }
                Button(action: { openLink(spotifyURL) }) { WellnessCircle(icon: "music.note.list", label: "Music", color: .pink) }
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.horizontal)
    }

    private var aiCompanionSectionContent: some View {
        HStack(spacing: 15) {
            ZStack {
                Circle().stroke(Color.purple.opacity(0.2), lineWidth: 1).frame(width: 50, height: 50)
                Image(systemName: "sparkles").foregroundColor(.purple)
            }
            VStack(alignment: .leading) {
                Text("Chat with AI Companion").font(.headline).foregroundColor(primaryTextColor)
                Text("In-app Wellness Guide").font(.subheadline).foregroundColor(.gray)
            }
            Spacer()
            Image(systemName: "chevron.right").foregroundColor(.gray)
        }
        .padding().background(cardColor).cornerRadius(20).padding(.horizontal)
    }

    private var sleepScheduleCard: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("SLEEP SCHEDULE").font(.caption.bold()).foregroundColor(.gray)
            HStack {
                VStack(alignment: .leading) { Text("10:30 PM").font(.title2.bold()).foregroundColor(primaryTextColor); Text("BEDTIME").font(.caption2).foregroundColor(.gray) }
                Spacer(); Image(systemName: "arrow.right").foregroundColor(.gray); Spacer()
                VStack(alignment: .trailing) { Text("6:30 AM").font(.title2.bold()).foregroundColor(primaryTextColor); Text("WAKE UP").font(.caption2).foregroundColor(.gray) }
            }
        }
        .padding().background(cardColor).cornerRadius(20).padding(.horizontal)
    }

    private var stressSummaryChart: some View {
        HStack(alignment: .bottom, spacing: 15) {
            ForEach(0..<7) { index in
                VStack {
                    RoundedRectangle(cornerRadius: 5).fill(index == 2 ? Color.orange : Color.teal.opacity(0.5)).frame(width: 25, height: [40, 60, 90, 45, 30, 25, 20][index])
                    Text(["M","T","W","T","F","S","S"][index]).font(.caption2).foregroundColor(.secondary)
                }
            }
        }
        .padding().frame(maxWidth: .infinity).background(cardColor).cornerRadius(20)
    }

    private var bottomTabBar: some View {
        HStack(spacing: 0) {
            TabItemButton(icon: "house.fill", label: "Home", isSelected: selectedTab == 0) { selectedTab = 0 }
            TabItemButton(icon: "leaf.fill", label: "Calm", isSelected: selectedTab == 1) { selectedTab = 1 }
            TabItemButton(icon: "person.2.fill", label: "Connect", isSelected: selectedTab == 2) { selectedTab = 2 }
            TabItemButton(icon: "sparkles", label: "AI", isSelected: selectedTab == 3) { selectedTab = 3 }
        }
        .padding(.vertical, 15).background(cardColor.shadow(color: .black.opacity(0.05), radius: 10, y: -5).ignoresSafeArea())
    }
    
    private var settingsSheet: some View {
        NavigationStack {
            List { Section("Appearance") { Toggle("Dark Mode", isOn: $isDarkMode) } }
            .navigationTitle("Settings").toolbar { Button("Done") { showSettings = false } }
        }
        .presentationDetents([.height(200)])
    }

    func openLink(_ url: URL) { UIApplication.shared.open(url) }
}

// MARK: - HELPER COMPONENTS

struct TabItemButton: View {
    let icon: String; let label: String; let isSelected: Bool; let action: () -> Void
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon).font(.system(size: 20))
                Text(label).font(.system(size: 10))
            }
            .frame(maxWidth: .infinity)
            .foregroundColor(isSelected ? .purple : .gray)
        }
    }
}

struct WellnessCircle: View {
    let icon: String; let label: String; let color: Color
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle().fill(color.opacity(0.15)).frame(width: 55, height: 55)
                Image(systemName: icon).font(.system(size: 22)).foregroundColor(color)
            }
            Text(label).font(.system(size: 10, weight: .medium)).foregroundColor(.gray)
        }
    }
}

// MARK: - PLACEHOLDER VIEWS
struct CalmView: View { var body: some View { Text("Calm Space 🌿").font(.largeTitle) } }
struct ConnectView: View { var body: some View { Text("Connect Space 🤝").font(.largeTitle) } }
