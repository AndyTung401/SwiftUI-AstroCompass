//
//  ContentView.swift
//  AstroCompass
//
//  Created by 董承威 on 2023/12/22.
//

import SwiftUI
import CoreLocation

class LocationViewModel: NSObject, ObservableObject {
    private var locationManager: CLLocationManager?
    @Published var speed: Double = 0.0
    @Published var lat: Double = 0.0
    @Published var lon: Double = 0.0
    @Published var alt: Double = 0.0
    @Published var azi: Double = 0.0
    @Published var log: String?
    
    init(locationManager: CLLocationManager = CLLocationManager()) {
        super.init()
        self.locationManager = locationManager
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
}

extension LocationViewModel: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            log = "Location authorization not determined"
        case .restricted:
            log = "Location authorization restricted"
        case .denied:
            log = "Location authorization denied"
        case .authorizedAlways:
            manager.requestLocation()
        case .authorizedWhenInUse:
            manager.startUpdatingLocation()
            manager.startUpdatingHeading()
        @unknown default:
            log = "Unknown authorization status"
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        self.azi = newHeading.trueHeading
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locations.forEach { location in
            self.speed = location.speed
            self.lat = location.coordinate.latitude
            self.lon = location.coordinate.longitude
            self.alt = location.altitude
        }
    }
}

public func degreeFormatter(_ input: Double) -> String{
    let input = abs(input)
    let degree = String(format: "%.0f", floor(input))
    let minute = String(format: "%.0f", floor(fmod(input, 1)*60))
    let second = String(format: "%.0f", fmod(fmod(input, 1)*60, 1)*60)
    return String("""
\(degree)º\(minute)’\(second)”
""")
}

struct LocationView: View {
    @ObservedObject private var locationViewModel = LocationViewModel()
    
    var body: some View {
        VStack(spacing: 5) {
            HStack {
                Image(systemName: "safari").foregroundStyle(.white).rotationEffect(Angle(degrees: -45-locationViewModel.azi))
                Spacer()
                Text("\(String(format:"%.1fº", locationViewModel.azi))")
                    .frame(width: 110, alignment: .trailing)

                switch locationViewModel.azi {
                case 0 ..< 22.5:
                    Text("N ").frame(width: 60, alignment: .leading)
                case 22.5 ..< 67.5:
                    Text("NE").frame(width: 60, alignment: .leading)
                case 67.5 ..< 112.5:
                    Text("E ").frame(width: 60, alignment: .leading)
                case 112.5 ..< 157.5:
                    Text("SE").frame(width: 60, alignment: .leading)
                case 157.5 ..< 202.5:
                    Text("S ").frame(width: 60, alignment: .leading)
                case 202.5 ..< 247.5:
                    Text("SW").frame(width: 60, alignment: .leading)
                case 247.5 ..< 292.5:
                    Text("W ").frame(width: 60, alignment: .leading)
                case 292.5 ..< 337.5:
                    Text("NW").frame(width: 60, alignment: .leading)
                case 337.5 ... 360.0:
                    Text("N ").frame(width: 60, alignment: .leading)
                default:
                    Text("")
                }
            }
            .frame(width: 230)
            .font(.system(size: 35))
            .fontWeight(.light)
            .padding(.bottom, 5)
            
            if locationViewModel.log != .none{
                Text(locationViewModel.log ?? "").foregroundStyle(.red)
            }
            
            HStack(spacing: 15){
                Text("\(degreeFormatter(locationViewModel.lat)) \(locationViewModel.lat<0 ? "S" : "N")").frame(width: 125, alignment: .trailing)
                Text("\(degreeFormatter(locationViewModel.lon)) \(locationViewModel.lon<0 ? "W" : "E")").frame(width: 125, alignment: .leading)
            }
        }.font(.title3)
    }
}


#Preview {
    LocationView()
}
