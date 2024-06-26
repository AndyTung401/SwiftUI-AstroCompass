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
    @Binding var pitch: Double
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
        .onChange(of: pitch) { _, pitch in
            for index in 0...87 {
                if calc.Dec.Dec*180/Double.pi < (Stars[index].Dec + Stars[index].rootArea/2) && calc.Dec.Dec*180/Double.pi > (Stars[index].Dec - Stars[index].rootArea/2) && calc.RA.RA < (Stars[index].RA + Stars[index].rootArea/30) && calc.RA.RA > (Stars[index].RA - Stars[index].rootArea/30){
                    pointedStar = (Stars[index].EngName,Stars[index].ChineseName)
                }
            }
        }
            
    }
}
