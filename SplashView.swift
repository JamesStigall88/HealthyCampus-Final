//
//  SplashView.swift
//  HealthyCampus-Demo
//
//  Created by Admin on 2/10/26.
//

import SwiftUI

extension Color {
    init(hex: Int, opacity: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: opacity
        )
    }
}

struct SplashView: View {
    @State var isActive: Bool = false
        
    var body: some View {
        ZStack{
            if self.isActive{
                MainView()
            } else{
                Rectangle()
                    .background(Color.black)
                    //.foregroundStyle(Color(hex: 0x414A6E))
                LinearGradient(
                    gradient: Gradient(colors: [Color(hex: 0x414A6E), Color.indigo, Color.white]), // Array of colors
                                startPoint: .top, // Starting point (e.g., .top, .leading)
                                endPoint: .bottom // Ending point (e.g., .bottom, .trailing)
                            )
                Image("Copy of HealthyCampus Logo-3")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180, height: 180)
                Text("Welcome\nto\n\nRest Up,\nCool Down!\n")
                    .font(.title)
                    .foregroundColor(.white)
                    //.padding() // Add padding around the text
                    /*.background(Color(hex: 0x414A6E).opacity(0.5)) // Optional: adds a semi-transparent background for readability*/
                    .padding(.top, 50) // Optional: adjust vertical position
                    .padding(.bottom, 450) // Optional: adjust vertical position
                    .multilineTextAlignment(.center)
                    .fontDesign(.serif)
                    .bold()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5){
                withAnimation{
                    self.isActive = true
                }
            }
        }
    }
        //.background(Color(hex: 0x414A6E))
}

struct SplashView_Previews: PreviewProvider{
    static var previews: some View{
        SplashView()
            //.background(Color(hex: 0x414A6E))
    }
}

/*#Preview {
    SplashView()
}*/
