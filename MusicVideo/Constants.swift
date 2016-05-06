//
//  Constants.swift
//  MusicVideo
//
//  Created by Francisco Navarro Madueño on 11/03/16.
//  Copyright © 2016 Francisco Navarro Madueño. All rights reserved.
//

import Foundation

//we'll use JSONDictionary and JSONArray for storin json data from apple api server
typealias JSONDictionary = [String: AnyObject]
typealias JSONArray = Array <AnyObject>

//Values you have to use if you want to get something from MusicVideoDefaults class
public struct NSUserDefaultsKeys{
    static let securitySettings = "SecSettings"
    static let apiCNT = "APICNT"
    static let bestImageQuality = "QualitySettings"
}


//Possible values for internet status
enum InternetStatus: CustomStringConvertible{
    case WIFI
    case NOACCESS
    case WWAN
    
    var description: String{
            get {
                switch self {
                case .WIFI:
                    return "WIFI available"
                case .NOACCESS:
                    return "No internet Access"
                case .WWAN:
                    return "Cellular Access Available"
                }
            }
        
    }
}

//Possible values for internet status

enum ImageQualityType: String,CustomStringConvertible{
    case low = "low"
    case medium = "medium"
    case best = "best"
    
    var description: String{
        get {
            switch self {
            case .low:
                return "100x100"
            case .medium:
                return "300x300"
            case .best:
                return "600x600"
            }
        }
        
    }
}