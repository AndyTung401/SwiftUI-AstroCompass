//
//  motionView.swift
//  AstroCompass
//
//  Created by 董承威 on 2023/12/22.
//

import SwiftUI
import CoreMotion


struct motionView: View {
    @Binding var pitch:Double

    var body: some View {
        HStack{
            Image(systemName: "angle").foregroundStyle(.white)
            Spacer()
            Text("\(String(format:"%.1fº", 180*pitch/Double.pi))")
                .frame(width: 110, alignment: .trailing)
            Text(" ").frame(width: 60)
        }//stack
        .frame(width: 230)
        .font(.system(size: 35))
        .fontWeight(.light)
    }//view
}//struct
