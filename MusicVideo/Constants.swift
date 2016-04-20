//
//  Constants.swift
//  MusicVideo
//
//  Created by Francisco Navarro Madueño on 11/03/16.
//  Copyright © 2016 Francisco Navarro Madueño. All rights reserved.
//

import Foundation

typealias JSONDictionary = [String: AnyObject]

typealias JSONArray = Array <AnyObject>


public struct NSUserDefaultsKeys{
    static let securitySettings = "SecSettings"
    static let apiCNT = "APICNT"
    static let bestImageQuality = "QualitySettings"
}


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