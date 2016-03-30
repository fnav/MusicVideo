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

public struct API {
    //Max 200
    static let maxNumVideos = 200
    static var limit = 200{
        willSet{
            if(newValue>maxNumVideos){
                self.limit = maxNumVideos
            }else{
                self.limit = newValue
            }
        }
    }
    static let DefaultsKey = "https://itunes.apple.com/us/rss/topmusicvideos/limit=\(limit)/json"
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