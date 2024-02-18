//
//  starView.swift
//  AstroCompass
//
//  Created by 董承威 on 2023/12/29.
//

import SwiftUI
import CoreMotion
import CoreLocation

struct starView: View {
    @ObservedObject private var locationViewModel = LocationViewModel()
    @State private var pitch = Double.zero
    let motionManager = CMMotionManager()
    let queue = OperationQueue()
    @State var calc = (JDN:"", GST:"", LST:"", HA:(HAh:"", HAm:"", HAs:""), RA:(RA:0.0, RAh:"", RAm:"", RAs:""), Dec:(Dec:0.0, Dech:"", Decm:"", Decs:"", DecSign:""))
    @State var pointedStar = (engName:"",chName:"")
    
    var body: some View {
        VStack{
            Text("\(pointedStar.chName)")
                .font(.system(size: 50))
            Text("\(pointedStar.engName)")
                .font(.system(size: 25))
        }
        .fontWeight(.thin)
        .lineLimit(1)
        .minimumScaleFactor(0.5)
        .padding(.horizontal,5)
        .onAppear {
            self.motionManager.startDeviceMotionUpdates(to: self.queue) { (data: CMDeviceMotion?, error: Error?) in
                guard let data = data else { return }
                let attitude: CMAttitude = data.attitude

                DispatchQueue.main.async {
                    self.pitch = attitude.pitch
                    calc = calculation(locationViewModel.azi, locationViewModel.lon, locationViewModel.lat, pitch)
                }
                
                for index in 0...87{
                    if calc.Dec.Dec*180/Double.pi < (Stars[index].Dec + Stars[index].rootArea/2) && calc.Dec.Dec*180/Double.pi > (Stars[index].Dec - Stars[index].rootArea/2) && calc.RA.RA < (Stars[index].RA + Stars[index].rootArea/30) && calc.RA.RA > (Stars[index].RA - Stars[index].rootArea/30){
                        pointedStar = (Stars[index].EngName,Stars[index].ChineseName)
                    }
                }
            }
        }//.onappear
            
    }
}

#Preview {
    starView()
}
