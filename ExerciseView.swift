//
//  ExerciseView.swift
//  HealthyCampus-Main-2
//
//  Created by Precious on 3/27/26.
//
import SwiftUI

struct Workout: Identifiable {
    let id = UUID()
    let title: String
    let duration: String
    let intensity: String
    let image: String
    let color: Color
}

struct ExerciseView: View {
    @Environment(\.dismiss) var dismiss
    
    // Updated workout list with more variety
    let featuredWorkouts = [
        Workout(title: "Morning Yoga", duration: "10 min", intensity: "Easy", image: "figure.yoga", color: .indigo),
        Workout(title: "Quick HIIT", duration: "15 min", intensity: "Medium", image: "figure.highintensity.intervaltraining", color: .orange),
        Workout(title: "Core Power", duration: "12 min", intensity: "Easy", image: "figure.core.training", color: .green),
        Workout(title: "Desk Stretch", duration: "5 min", intensity: "Very Easy", image: "figure.flexibility", color: .blue)
    ]
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 25) {
                
                // HEADER
                HStack {
                    VStack(alignment: .leading) {
                        Text("Explore")
                            .font(.system(size: 34, weight: .bold, design: .rounded))
                        Text("EASY WORKOUTS")
                            .font(.caption.bold())
                            .foregroundColor(.gray)
                            .tracking(1)
                    }
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                            .foregroundColor(.gray.opacity(0.3))
                    }
                }
                .padding(.horizontal)
                .padding(.top, 20)

                // FEATURED CARD (Large Hero Style)
                featuredHeroCard
                
                // WORKOUT LIST
                VStack(alignment: .leading, spacing: 15) {
                    Text("RECOMMENDED FOR YOU")
                        .font(.caption.bold())
                        .foregroundColor(.gray)
                        .tracking(1)
                        .padding(.horizontal)
                    
                    ForEach(featuredWorkouts) { workout in
                        // Clicking this takes you to the Timer
                        NavigationLink(destination: WorkoutTimerView(workout: workout)) {
                            WorkoutCard(workout: workout)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            .padding(.bottom, 30)
        }
        .background(Color(red: 0.98, green: 0.98, blue: 1.0).ignoresSafeArea())
        .navigationBarHidden(true)
    }
    
    private var featuredHeroCard: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: 25)
                .fill(LinearGradient(colors: [.purple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(height: 180)
            
            VStack(alignment: .leading, spacing: 5) {
                Text("New Challenge")
                    .font(.caption.bold())
                    .foregroundColor(.white.opacity(0.8))
                Text("7-Day Calm Streak")
                    .font(.title2.bold())
                    .foregroundColor(.white)
            }
            .padding(25)
        }
        .padding(.horizontal)
        .shadow(color: .blue.opacity(0.2), radius: 10, y: 5)
    }
}

// MARK: - SUPPORTING VIEWS

struct WorkoutCard: View {
    let workout: Workout
    
    var body: some View {
        HStack(spacing: 20) {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(workout.color.opacity(0.15))
                    .frame(width: 70, height: 70)
                Image(systemName: workout.image)
                    .font(.title)
                    .foregroundColor(workout.color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(workout.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                HStack {
                    Text(workout.duration)
                    Text("•")
                    Text(workout.intensity)
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "play.circle.fill")
                .font(.title2)
                .foregroundColor(.purple)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .padding(.horizontal)
        .shadow(color: .black.opacity(0.02), radius: 8, y: 4)
    }
}

// MARK: - TIMER VIEW (The Active Workout)

struct WorkoutTimerView: View {
    let workout: Workout
    @State private var timeRemaining = 60 // Set to 60s for a quick demo
    @State private var isActive = true
    @Environment(\.dismiss) var dismiss
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 50) {
            Text(workout.title)
                .font(.largeTitle.bold())
            
            ZStack {
                Circle()
                    .stroke(workout.color.opacity(0.2), lineWidth: 15)
                Circle()
                    .trim(from: 0, to: CGFloat(timeRemaining) / 60.0)
                    .stroke(workout.color, style: StrokeStyle(lineWidth: 15, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .animation(.linear(duration: 1), value: timeRemaining)
                
                Text("\(timeRemaining)")
                    .font(.system(size: 80, weight: .bold, design: .rounded))
            }
            .frame(width: 250, height: 250)

            Button(action: { dismiss() }) {
                Text("End Workout")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Capsule().fill(Color.red.opacity(0.8)))
                    .padding(.horizontal, 60)
            }
        }
        .onReceive(timer) { _ in
            if timeRemaining > 0 && isActive {
                timeRemaining -= 1
            }
        }
    }
}
