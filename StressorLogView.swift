//
//  StressorLogView.swift
//  HealthyCampus-Demo
//
//  Created by Admin on 2/15/26.
//

import SwiftUI

struct StressorEntry: Identifiable {
    let id = UUID()
    let text: String
    let category: String
    let date: Date
}

struct StressorLogView: View {
    @Environment(\.dismiss) var dismiss
    @State private var stressorText: String = ""
    @State private var selectedCategory: String = "General"
    @State private var savedEntries: [StressorEntry] = [] // Stores your notes
    
    let categories = ["General", "Academic", "Social", "Health", "Financial"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            // Header
            VStack(alignment: .leading, spacing: 8) {
                Text("What's on your mind?")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(Color(red: 0.1, green: 0.2, blue: 0.4))
                
                Text("Jot down your stressors. We'll keep track of the time for you.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)
            
            // Category Picker
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(categories, id: \.self) { category in
                        Button(action: { selectedCategory = category }) {
                            Text(category)
                                .font(.system(size: 14, weight: .medium))
                                .padding(.vertical, 8).padding(.horizontal, 16)
                                .background(selectedCategory == category ? Color.purple : Color.white)
                                .foregroundColor(selectedCategory == category ? .white : .purple)
                                .cornerRadius(20)
                                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.purple, lineWidth: 1))
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            // Text Entry
            TextEditor(text: $stressorText)
                .padding(10)
                .frame(height: 150)
                .background(Color.white)
                .cornerRadius(15)
                .shadow(color: .black.opacity(0.05), radius: 5)
                .padding(.horizontal)
                .overlay(
                    Group {
                        if stressorText.isEmpty {
                            Text("Start typing here...").foregroundColor(.gray.opacity(0.5)).padding(.leading, 30).padding(.top, 10)
                        }
                    }, alignment: .topLeading
                )

            // Save Button
            Button(action: {
                let newEntry = StressorEntry(text: stressorText, category: selectedCategory, date: Date())
                savedEntries.insert(newEntry, at: 0) // Adds to the top of the list
                stressorText = "" // Clear the box
                
                // Optional: dismiss() // Uncomment if you want to go home immediately after saving
            }) {
                Text("Save & Log Stressor")
                    .font(.headline).foregroundColor(.white)
                    .frame(maxWidth: .infinity).padding()
                    .background(stressorText.isEmpty ? Color.gray : Color.purple).cornerRadius(15)
            }
            .disabled(stressorText.isEmpty)
            .padding(.horizontal)

            // SAVED HISTORY
            Text("RECENT LOGS")
                .font(.caption.bold()).foregroundColor(.gray).padding(.horizontal)
            
            List(savedEntries) { entry in
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Text(entry.category).font(.caption.bold()).foregroundColor(.purple)
                        Spacer()
                        Text(entry.date.formatted(date: .abbreviated, time: .shortened))
                            .font(.caption2).foregroundColor(.secondary)
                    }
                    Text(entry.text).font(.body)
                }
                .listRowBackground(Color.clear)
            }
            .listStyle(.plain)
        }
        .background(Color(red: 0.98, green: 0.98, blue: 1.0).ignoresSafeArea())
        .navigationTitle("Journal")
        .navigationBarTitleDisplayMode(.inline)
    }
}
