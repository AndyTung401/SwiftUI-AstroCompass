//
//  motionView.swift
//  AstroCompass
//
//  Created by 董承威 on 2023/12/22.
//

import SwiftUI
import CoreMotion


struct motionView: View {
    let motionManager = CMMotionManager()
    let queue = OperationQueue()
    @State private var pitch = Double.zero

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
    }//view
}//struct

#Preview {
    motionView()
}
