//
//  ChaTvIEW.swift
//  HealthyCampus-Main-2
//
//  Created by Precious on 3/30/26.
//
import SwiftUI

struct Message: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool
}

struct ChatView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @State private var messages: [Message] = [
        Message(text: "Hi Bulldog! I'm your in-app wellness guide. How are you feeling?", isUser: false)
    ]
    @State private var newMessage: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            // 1. MESSAGES LIST
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(messages) { message in
                            chatBubble(for: message)
                                .id(message.id)
                        }
                    }
                    .padding()
                }
                .onChange(of: messages.count) { oldValue, newValue in
                    if let lastId = messages.last?.id {
                        withAnimation {
                            proxy.scrollTo(lastId, anchor: .bottom)
                        }
                    }
                }
            }
            
            divider
            
            // 2. INPUT AREA
            inputField
        }
        .navigationTitle("AI Companion")
        .navigationBarTitleDisplayMode(.inline)
        .background(isDarkMode ? Color(red: 0.05, green: 0.07, blue: 0.12) : Color(red: 0.98, green: 0.98, blue: 1.0))
    }
    
    // MARK: - COMPONENTS
    
    private func chatBubble(for message: Message) -> some View {
        HStack {
            if message.isUser { Spacer() }
            
            Text(message.text)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(message.isUser ? Color.purple : (isDarkMode ? Color.gray.opacity(0.2) : .white))
                .foregroundColor(message.isUser ? .white : (isDarkMode ? .white : .primary))
                .cornerRadius(20, corners: message.isUser ? [.topLeft, .topRight, .bottomLeft] : [.topLeft, .topRight, .bottomRight])
                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
            
            if !message.isUser { Spacer() }
        }
    }
    
    private var inputField: some View {
        HStack(spacing: 12) {
            TextField("Ask me anything...", text: $newMessage)
                .padding(12)
                .background(isDarkMode ? Color.white.opacity(0.05) : .white)
                .cornerRadius(25)
                .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.gray.opacity(0.2), lineWidth: 1))
            
            Button(action: sendMessage) {
                Image(systemName: "paperplane.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(Color.purple)
                    .clipShape(Circle())
            }
            .disabled(newMessage.trimmingCharacters(in: .whitespaces).isEmpty)
        }
        .padding()
        .background(isDarkMode ? Color(red: 0.12, green: 0.15, blue: 0.22) : .white)
    }
    
    private var divider: some View {
        Rectangle()
            .frame(height: 1)
            .foregroundColor(Color.gray.opacity(0.1))
    }
    
    // MARK: - LOGIC
    
    func sendMessage() {
        let userText = newMessage.trimmingCharacters(in: .whitespaces)
        guard !userText.isEmpty else { return }
        
        // Add User Message
        messages.append(Message(text: userText, isUser: true))
        newMessage = ""
        
        // Simulate AI "Thinking"
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let response = generateMockResponse(for: userText)
            messages.append(Message(text: response, isUser: false))
        }
    }
    
    func generateMockResponse(for input: String) -> String {
        let lower = input.lowercased()
        if lower.contains("sleep") { return "I see you're asking about sleep. Try setting your bedtime to 10:30 PM for a full 8-hour rest." }
        if lower.contains("stressed") || lower.contains("anxious") { return "I'm sorry you're feeling that way. Would you like to try a 4-minute breathing exercise?" }
        return "That's interesting! I'm here to help you stay on track with your wellness goals. What else is on your mind?"
    }
}

// Helper to round specific corners
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
