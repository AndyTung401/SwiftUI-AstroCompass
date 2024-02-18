//
//  calculationFunc.swift
//  AstroCompass
//
//  Created by 董承威 on 2023/12/24.
//

import Foundation
func calculation(_ Az:Double, _ lon:Double, _ lat:Double, _ alt:Double) -> (JDN:String, GST:String, LST:String, HA:(HAh:String, HAm:String, HAs:String), RA:(RA:Double, RAh:String, RAm:String, RAs:String), Dec:(Dec:Double, Dech:String, Decm:String, Decs:String, DecSign:String)){
    //GET USER DATA//
    let date = Date()
    var calender = Calendar.current
    let userTime = ["h": Double(calender.component(.hour, from: date)),
                       "m": Double(calender.component(.minute, from: date)),
                       "s": Double(calender.component(.second, from: date))]

    calender.timeZone = TimeZone(abbreviation: "UTC")!
    let UTCdate = ["Y": Double(calender.component(.year, from: date)),
                       "M": Double(calender.component(.month, from: date)),
                       "D": Double(calender.component(.day, from: date))]
    let UTCtime = ["h": Double(calender.component(.hour, from: date)),
                       "m": Double(calender.component(.minute, from: date)),
                       "s": Double(calender.component(.second, from: date))]
    let decHours = UTCtime["h"]! + UTCtime["m"]!/60 + UTCtime["s"]!/3600

    
    let locationData = ["Az": Az * Double.pi / 180,
                        "Alt": alt,
                        "Lon": lon * Double.pi / 180,
                        "Lat": lat * Double.pi / 180]
    let UTCdiff = locationData["Lon"]!*12/Double.pi
    
    
    //CALCULATE JULIAN DATE//
    let a = floor((14-UTCdate["M"]!)/12)
    let y = UTCdate["Y"]! + 4800 - a
    let m = UTCdate["M"]! + 12*a - 3
    let julianDate = UTCdate["D"]! + floor((153*m+2)/5) + 365*y + floor(y/4) - floor(y/100) + floor(y/400) - 32045.5


    //CALCULATE GREENWICH SIDEREAL TIME//
    let S = julianDate - 2451545
    let T = S/36525
    var gst = 6.697374558 + 2400.051336*T + 0.000025862*pow(T, 2)
    if (gst>0 ? 1:(gst<0 ? -1:0)) == -1 { gst = gst + 24*abs(floor(gst/24)) } else { gst = gst - 24*abs(floor(gst/24)) }
    gst = gst + decHours*1.002737909
    if gst < 0 {gst += 24}
    if gst > 24 {gst -= 24}

    let gstH = floor(gst)
    let gstM = floor((gst - gstH)*60)
    let gstS = floor(((gst - gstH)*60 - gstM)*60)


    //CALCULATE LOCAL SIDEREAL TIME//
    var lst = gst + UTCdiff
    if lst > 24 {lst -= 24}
    if lst < 0 {lst += 24}

    let lstH = floor(lst)
    let lstM = floor((lst - lstH)*60)
    let lstS = floor(((lst - lstH)*60 - lstM)*60)

    //CALCULATE DECLINATION//
    let Dec = asin(sin(locationData["Alt"]!)*sin(locationData["Lat"]!) + cos(locationData["Alt"]!)*cos(locationData["Lat"]!)*cos(locationData["Az"]!)) //in rad
    let DecD = Dec * 180 / Double.pi
    let DecM = fmod(DecD, 1) * 60
    let DecS = fmod(DecM, 1) * 60


    //CALCULATE RIGHT ASCENSION//
    let sinHourAngle = -sin(locationData["Az"]!)*cos(locationData["Alt"]!)/cos(Dec)
    let cosHourAngle = (sin(locationData["Alt"]!)-sin(Dec)*sin(locationData["Lat"]!))/cos(Dec)/cos(locationData["Lat"]!)
    var hourAngle = acos(cosHourAngle)
    if sinHourAngle < 0 {hourAngle = 2*Double.pi - hourAngle}
    hourAngle = hourAngle * 12 / Double.pi
    hourAngle = hourAngle.isNaN ? 1.0 : hourAngle
    let hourAngleM = fmod(hourAngle, 1) * 60
    let hourAngleS = fmod(hourAngleM, 1) * 60
    var RA = lst - hourAngle
    if RA < 0 {RA += 24}
    if RA > 24 {RA -= 24}
    let RAM = fmod(RA, 1)*60
    let RAS = fmod(RAM, 1)*60



    //OUTPUT//
    let rJDN = "JDN: \(String(format: "%.5f", julianDate + userTime["h"]!/24 + userTime["m"]!/1440 + userTime["s"]!/86400))"
    let rGST = "GST: \(String(format: "%02d", Int(gstH)))h \(String(format: "%02d", Int(gstM)))m \(String(format: "%02d", Int(gstS)))s"
    let rLST = "LST: \(String(format: "%02d", Int(lstH)))h \(String(format: "%02d", Int(lstM)))m \(String(format: "%02d", Int(lstS)))s"
    let rHAh = String(format: "%02d", Int(hourAngle))
    let rHAm = String(format: "%02d", Int(hourAngleM))
    let rHAs = String(format: "%02d", Int(hourAngleS))
    let rRAh = String(format: "%02d", Int(RA))
    let rRAm = String(format: "%02d", Int(RAM))
    let rRAs = String(format: "%02d", Int(RAS))
    let rDecSign = Dec<0 ? "-" : ""
    let rDech = String(format: "%02d", abs(Int(DecD)))
    let rDecm = String(format: "%02d", abs(Int(DecM)))
    let rDecs = String(format: "%02d", abs(Int(DecS)))
    return (rJDN, rGST, rLST, (rHAh, rHAm, rHAs), (RA, rRAh, rRAm, rRAs), (Dec, rDech, rDecm, rDecs, rDecSign))
}
