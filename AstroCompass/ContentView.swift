//
//  LocationView.swift
//  AstroCompass
//
//  Created by 董承威 on 2023/12/22.
//

import SwiftUI


struct ContentView: View {
    @State var enableDarkMode = false
    var body: some View {
        ZStack{
            VStack{
                Image(systemName: "arrow.up").font(.title).fontWeight(.light)
                Text("Aim toward the target").font(.callout)
                Spacer()
            }
            
            VStack(spacing: 10) {
                motionView()
                LocationView()
            }.padding(.top, 240)
            
            VStack(spacing: 0){
                calculationView()
            }
            

            Button{
                enableDarkMode.toggle()
            } label: {
                if enableDarkMode {
                    Image(systemName: "circle.lefthalf.filled")
                        .font(.system(size: 50)).foregroundStyle(.white)
                } else {
                    Image(systemName: "circle.lefthalf.filled")
                        .font(.system(size: 50)).foregroundStyle(.white).rotationEffect(.degrees(180))
                }
            }
            .padding(.top, 470)
        }
        .monospacedDigit()
        .opacity(0.9)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(enableDarkMode==true ? Color(.black):Color(.systemGray6).opacity(0.8))
        .colorMultiply(enableDarkMode==true ? Color(.red):Color(.white))
        .animation(.easeInOut, value: enableDarkMode)
    }
}


#Preview {
    ContentView()
}
