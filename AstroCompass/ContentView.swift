//
//  LocationView.swift
//  AstroCompass
//
//  Created by 董承威 on 2023/12/22.
//

import SwiftUI
import CoreMotion


struct ContentView: View {
    let motionManager = CMMotionManager()
    let queue = OperationQueue()
    @State var enableDarkMode = false
    @State var pitch = Double.zero
    var body: some View {
        ZStack{
            VStack{
                Image(systemName: "arrow.up").font(.title).fontWeight(.light)
                Text("Aim toward the target").font(.callout)
                Spacer()
            }
            
            VStack(spacing: 10) {
                motionView(pitch: $pitch)
                LocationView()
            }.padding(.top, 240)
            
            VStack(spacing: 0){
                calculationView(pitch: $pitch)
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
        .onAppear
        {
            self.motionManager.startDeviceMotionUpdates(to: self.queue) { (data: CMDeviceMotion?, error: Error?) in
                guard let data = data else { return }
                let attitude: CMAttitude = data.attitude
                DispatchQueue.main.async {
                    self.pitch = attitude.pitch
                }
            }
        }//.onappear
    }
}


#Preview {
    ContentView()
}
