//
//  MusicVideo.swift
//  MusicVideo
//
//  Created by Francisco Navarro Madueño on 11/03/16.
//  Copyright © 2016 Francisco Navarro Madueño. All rights reserved.
//

import Foundation

class Video{
    
    //Struct with the API paths
    private struct APIVideoConstants{
          static let imageName = "im:name/label"
          static let rights = "rights/label"
          static let price = "im:price/label"
          static let imageURL = "im:image/2/label"
          static let artist = "im:artist/label"
          static let videoURL = "link/1/attributes/href"
          static let iMid = "id/attributes/im:id"
          static let genre = "category/attributes/term"
          static let linkToiTunes = "id/label"
          static let releaseDate = "im:releaseDate/attributes/label"
    }
    
    //Public vars
    
    //save video rank in iTunes
    var vRank = 0
    
    //Image quality. If user doesn't set, put low
    private var _vImageQuality:ImageQualityType = ImageQualityType.best{
        didSet{
            //Everytime _imageQuality is setted we'll change the _vImageUrl size
            _vImageUrl = _vImageUrl.stringByReplacingOccurrencesOfString(oldValue.description, withString: _vImageQuality.description)
        }
    }
    
    //Private vars
    private var _vName:String
    private var _vRights:String
    private var _vPrice:String
    private var _vImageUrl:String
    private var _vArtist:String
    private var _vVideoUrl:String
    private var _vImid:String
    private var _vGenre:String
    private var _vLinkToiTunes:String
    private var _vReleaseDte:String
    
    // This variable gets created from the UI
    var vImageData:NSData?
    
    //Make a getter
    
    var vName: String{
        return _vName
    }
    
    var vRights: String{
        return _vRights
    }
    
    var vPrice: String{
        return _vPrice
    }
    
    var vImageUrl: String{
        return _vImageUrl
    }
    
    var vArtist: String{
        return _vArtist
    }
    
    var vVideoUrl: String{
        return _vVideoUrl
    }
    
    var vImid: String{
        return _vImid
    }
    
    var vGenre: String{
        return _vGenre
    }
    
    var vLinkToiTunes: String{
        return _vLinkToiTunes
    }
    
    var vReleaseDte: String{
        return _vReleaseDte
    }
    
    //vImageQuality allow access to _vImageQuality from instance
    var vImageQuality:ImageQualityType{
        set{
            _vImageQuality = newValue
        }
        get{
            return _vImageQuality
        }
    }
    
    
    class func retrieveValueFromChain(chain:String, data:AnyObject)->String{
        
        var stringValue = ""
        
        let chainDivided = chain.componentsSeparatedByString("/")
        
        if (chainDivided.count>0)
        {
            var chainDividedReverse = Array(chainDivided.reverse())

            let newPart = chainDividedReverse.removeLast()
            let dataExtracted = data[newPart]
            
            switch dataExtracted{
                case let value as JSONDictionary:
                    stringValue = retrieveValueFromChain(chainDividedReverse.reverse().joinWithSeparator("/"),data: value)
                case let value as JSONArray:
                    if (chainDividedReverse.count>0){
                        let numberArray = chainDividedReverse.removeLast()
                        if let numberFromString = Int(numberArray){
                            let newData = value[numberFromString]
                           stringValue = retrieveValueFromChain(chainDividedReverse.reverse().joinWithSeparator("/"),data: newData)
                        }
                    }
                case let value as String:
                    stringValue = value
                default:
                    stringValue = ""
            }
        }
        
        return stringValue
    }

    
    init (data: JSONDictionary){
        
        let datos: JSONDictionary = data
        //set imageName
        _vName = Video.retrieveValueFromChain(APIVideoConstants.imageName, data: datos)
        //set imageURL
        let imageUrl = Video.retrieveValueFromChain(APIVideoConstants.imageURL, data: data)
            //We'll put the size that MusicVideoBrain specify at the moment we load _vImage Url
        let imageSize = imageQuality.description
        _vImageUrl = imageUrl.stringByReplacingOccurrencesOfString("100x100", withString:imageSize)
        //set videoURL
        _vVideoUrl = Video.retrieveValueFromChain(APIVideoConstants.videoURL, data: data)
        
        //set the homework's variables
        _vRights = Video.retrieveValueFromChain(APIVideoConstants.rights, data: data)
        _vPrice = Video.retrieveValueFromChain(APIVideoConstants.price, data: data)
        _vArtist = Video.retrieveValueFromChain(APIVideoConstants.artist, data: data)
        _vImid = Video.retrieveValueFromChain(APIVideoConstants.iMid, data: data)
        _vGenre = Video.retrieveValueFromChain(APIVideoConstants.genre, data: data)
        _vLinkToiTunes = Video.retrieveValueFromChain(APIVideoConstants.linkToiTunes, data: data)
        _vReleaseDte = Video.retrieveValueFromChain(APIVideoConstants.releaseDate, data: data)
        
    }
    
    deinit{
      //  print("Video with rank:\(vRank) called \(_vName) deallocated")
    }
    
    
}