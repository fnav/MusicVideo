//
//  MusicVideoDefaults.swift
//  MusicVideo
//
//  Created by Francisco Navarro Madueño on 17/04/16.
//  Copyright © 2016 Francisco Navarro Madueño. All rights reserved.
//

import Foundation

//We don't want anybody using different instances

class MusicVideoDefaults {
    
    //Michael comment: "Using static class member and marking the init as private will make sure the singleton is wrapped in dispatch_once blocks behind the scenes."
    static let sharedInstance = MusicVideoDefaults()
    
    private init() {} //This prevents others from using the default() initializer for this class.
    
    //MARK: Structs
    
    //Music video api default values
    private struct MVideoAPI {
        //maximun number of videos to fetch
        static let maxNumVideos = 200
        //default value for the first time you execute the app
        static let defaultLimitVideoCnt = 10
        //top music video url
        static var topMusicVideos = "https://itunes.apple.com/us/rss/topmusicvideos"
        
    }
    
    //MARK: Private parameters
    
    //Private vars
    
    private var _limit:Int?
    
    private var _securityEnabled:Bool?
    
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    //MARK: Private parameters
    
    //Security for touch ID
    var security:Bool{
        set{
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setBool(newValue, forKey: NSUserDefaultsKeys.securitySettings)
        }
        get{
            return defaults.boolForKey(NSUserDefaultsKeys.securitySettings)
        }
    }
    
    //Best quality for videos images
    var bestQuality:Bool{
        set{
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setBool(newValue, forKey: NSUserDefaultsKeys.bestImageQuality)
        }
        get{
            return defaults.boolForKey(NSUserDefaultsKeys.bestImageQuality)
        }
    }
    
    //number of videos to request
    var limit:Int{
        set{
            if(_limit != newValue){
                //Make sure the value added is not greater than max number
                if(newValue>MVideoAPI.maxNumVideos){
                    print("Limite puesto a \(newValue>MVideoAPI.maxNumVideos) por defecto")
                    _limit = MVideoAPI.maxNumVideos
                }else{
                    print("Limite puesto a \(newValue)")
                    _limit = newValue
                }
            }
            
            defaults.setObject(_limit, forKey:NSUserDefaultsKeys.apiCNT)
        }
        get{
            var limitNum = 0
            //If it's the first time limit is accesed try get from NSUserDefaults. If not, get a default value from MVideoAPI struct
            if let limitCnt = _limit{
                limitNum = limitCnt
            }else{
                if let limite = (defaults.objectForKey(NSUserDefaultsKeys.apiCNT))
                {
                    limitNum = Int(limite as! NSNumber)
                }else{
                    limitNum = MVideoAPI.defaultLimitVideoCnt
                }
                _limit = limitNum
            }
            return limitNum
        }
        
    }

}