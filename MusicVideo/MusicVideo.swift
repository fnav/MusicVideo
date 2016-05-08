//
//  MusicVideo.swift
//  MusicVideo
//
//  Created by Francisco Navarro Madueño on 11/03/16.
//  Copyright © 2016 Francisco Navarro Madueño. All rights reserved.
//

import Foundation

class Video{
    
  
    
    //MARK: -
    //MARK: Private parameters

       //Image quality for videos. Get initial value from imageQuality in ViewController.
    //Everytime _vImageQuality is set we want to make sure _vImageUrl and vImageData is updated based on internet status
    private var _vImageQuality:ImageQualityType{
        willSet{
            //If image quality is better than before we'll force the reload putting vImageData to nil
            switch newValue {
            case .medium:
                if(_vImageQuality.rawValue == ImageQualityType.low.rawValue){
                    //From .low to .medium
                    //If we have already the photo saved with a good quality we don't want to reset de data.
                    if(_vImageData?.quality.rawValue == ImageQualityType.low.rawValue){
                        vImageData = nil
                    }
                }
                //Change the imageURL for future loads
                vImageUrl = vImageUrl.stringByReplacingOccurrencesOfString(_vImageQuality.description, withString: newValue.description)
            case .best:
                if(_vImageQuality.rawValue == ImageQualityType.low.rawValue || _vImageQuality.rawValue == ImageQualityType.medium.rawValue){
                    //From .low or .medium to .best
                    //If we have already the photo saved with a good quality we don't want to reset de data.
                    if(_vImageData?.quality.rawValue != ImageQualityType.best.rawValue){
                        vImageData = nil
                    }
                }
                vImageUrl = vImageUrl.stringByReplacingOccurrencesOfString(_vImageQuality.description, withString: newValue.description)
            default:
                //Everytime _imageQuality is setted we'll change the _vImageUrl size
                vImageUrl = vImageUrl.stringByReplacingOccurrencesOfString(_vImageQuality.description, withString: newValue.description)
            }

        }
    }
    
    //Private vars
    private(set) var vRank:Int
    private(set) var vName:String
    private(set) var vRights:String
    private(set) var vPrice:String
    private(set) var vImageUrl:String
    private(set) var vArtist:String
    private(set) var vVideoUrl:String
    private(set) var vImid:String
    private(set) var vGenre:String
    private(set) var vLinkToiTunes:String
    private(set) var vReleaseDte:String
    
    // This variable gets created from the UI
    //private _vImageData will be use to store the qualityType of the NSData aldready loaded
    private var _vImageData:(data:NSData?,quality:ImageQualityType)?
 
    //MARK: -

    //MARK: Public parameters
    
    //vImageQuality allow access to _vImageQuality from instance
    var vImageQuality:ImageQualityType{
        set{
            _vImageQuality = newValue
        }
        get{
            return _vImageQuality
        }
    }
    
    var vImageData:NSData?{
        didSet{
            _vImageData = (vImageData,_vImageQuality)
        }
    }
    
    //MARK: -
    //MARK: Music Video Methods
    
    init(vRank:Int, vName:String, vRights:String, vPrice:String,
         vImageUrl:String, vArtist:String, vVideoUrl:String, vImid:String,
         vGenre:String, vLinkToiTunes:String, vReleaseDte:String,vImageQuality:ImageQualityType) {
        
        
        self.vRank = vRank
        self.vName = vName
        self.vRights = vRights
        self.vPrice = vPrice
        self.vImageUrl = vImageUrl
        self.vArtist = vArtist
        self.vVideoUrl = vVideoUrl
        self.vImid = vImid
        self.vGenre = vGenre
        self.vLinkToiTunes = vLinkToiTunes
        self.vReleaseDte = vReleaseDte
        self._vImageQuality = vImageQuality
        
    }
    
    deinit{
      //  print("Video with rank:\(vRank) called \(_vName) deallocated")
    }
    
    
}