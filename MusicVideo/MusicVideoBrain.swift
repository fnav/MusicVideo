//
//  MusicVideoBrain.swift
//  MusicVideo
//
//  Created by Francisco Navarro Madueño on 09/04/16.
//  Copyright © 2016 Francisco Navarro Madueño. All rights reserved.
//

import Foundation

private let sharedBrain = MusicVideoBrain()

class MusicVideoBrain {
    
    class var sharedInstance: MusicVideoBrain {
        return sharedBrain
    }
    
    enum ImageQualityType: String{
        case low = "low"
        case medium = "medium"
        case best = "best"
    }
    
    private var _limit:Int?
    private var _imageQuality:ImageQualityType?
    private var _securityEnabled:Bool?
    
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    var security:Bool{
        set{
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setBool(newValue, forKey: NSUserDefaultsKeys.securitySettings)
        }
        get{
            return defaults.boolForKey(NSUserDefaultsKeys.securitySettings)
        }
    }
    
    
    var bestQuality:Bool{
        set{
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setBool(newValue, forKey: NSUserDefaultsKeys.bestImageQuality)
        }
        get{
            return defaults.boolForKey(NSUserDefaultsKeys.bestImageQuality)
        }
    }
    
    var limit:Int{
        set{
            if(_limit != newValue){
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
            //If it's the first time limit is accesed try get from NSUserDefaults. If not, set a default value from MusicVideoAPIConstants
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

