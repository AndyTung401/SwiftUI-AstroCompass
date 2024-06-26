//
//  Calculation.swift
//  AstroCompass
//
//  Created by 董承威 on 2023/12/24.
//

import Foundation
import CoreMotion
import CoreLocation
import SwiftUI

struct calculationView: View{
    @ObservedObject private var locationViewModel = LocationViewModel()
    @Binding var pitch: Double
    @State var calc = (JDN:"", GST:"", LST:"", HA:(HAh:"", HAm:"", HAs:""), RA:(RA:0.0, RAh:"", RAm:"", RAs:""), Dec:(Dec:0.0, Dech:"", Decm:"", Decs:"", DecSign:""))
    var body: some View{
        VStack{
            VStack{
                HStack(alignment: .bottom, spacing: 0){
                    Text("RA:").padding(.bottom,5).frame(width: 45, alignment: .trailing)
                    Spacer()
                    Text("\(calc.RA.RAh)").font(.system(size: 40)).fontWeight(.thin)
                    Text("h ").padding(.bottom,5)
                    Text("\(calc.RA.RAm)").font(.system(size: 40)).fontWeight(.thin)
                    Text("m ").padding(.bottom,5)
                    Text("\(calc.RA.RAs)").font(.system(size: 40)).fontWeight(.thin)
                    Text("s ").padding(.bottom,5)
                }.font(.title2).frame(width: 260)
                HStack(alignment: .bottom, spacing: 0){
                    Text("Dec:").padding(.bottom,7).frame(width: 45, alignment: .trailing)
                    Spacer()
                    Text("\(calc.Dec.DecSign)").font(.system(size: 40)).fontWeight(.thin).frame(width: 20)
                    Text("\(calc.Dec.Dech)").font(.system(size: 40)).fontWeight(.thin)
                    Text("º ").padding(.bottom,17)
                    Text("\(calc.Dec.Decm)").font(.system(size: 40)).fontWeight(.thin)
                    Text("’ ").padding(.bottom,17)
                    Text("\(calc.Dec.Decs)").font(.system(size: 40)).fontWeight(.thin)
                    Text("” ").padding(.bottom,17)
                }.font(.title2).frame(width: 260)
                
                Divider().overlay(.white).padding(.top, -5).frame(width: 300)
                
                starView(pitch: $pitch)
                    .padding(.vertical, 15)
            }
            .padding(20)
            .overlay{
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white, lineWidth: 1)
            }
            .padding(.top, 90)
            
            Spacer()
            
            Text("\(calc.JDN)")
            Text("\(calc.GST)")
            Text("\(calc.LST)")
            HStack(spacing: 0){
                Text("HA: ")
                Text("\(calc.HA.HAh)").monospacedDigit()
                Text("h ")
                Text("\(calc.HA.HAm)").monospacedDigit()
                Text("m ")
                Text("\(calc.HA.HAs)").monospacedDigit()
                Text("s")
            }
        }
        .onChange(of: pitch) { _, pitch in
            calc = calculation(locationViewModel.azi, locationViewModel.lon, locationViewModel.lat, pitch)
        }
    }

}
#Preview{calculationView(pitch: ContentView().$pitch)}
