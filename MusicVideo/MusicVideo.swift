//
//  MusicVideo.swift
//  MusicVideo
//
//  Created by Francisco Navarro Madueño on 11/03/16.
//  Copyright © 2016 Francisco Navarro Madueño. All rights reserved.
//

import Foundation

class Video{
    
    
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
    //Data encapsulation
    
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
    
    //Make a getter
    
    var vName: String{
        return _vName
    }
    
    var vImageUrl: String{
        return _vImageUrl
    }
    
    var vVideoUrl: String{
        return _vVideoUrl
    }
    
    
    class func retrieveValueFromChain(chain:String, data:AnyObject)->String{
        
        var stringValue = ""
        
        var chainDivided = chain.componentsSeparatedByString("/")
        
        if (chainDivided.count>0)
        {
            
            let newPart = chainDivided.removeLast()
            let dataExtracted = data[newPart]
            
            switch dataExtracted{
            case let value as JSONDictionary:
                retrieveValueFromChain(chainDivided.joinWithSeparator("/"),data: value)
            case let value as JSONArray:
                if (chainDivided.count>0){
                    let numberArray = chainDivided.removeLast()
                    if let numberFromString = Int(numberArray){
                        let newData = value[numberFromString]
                        retrieveValueFromChain(chainDivided.joinWithSeparator("/"),data: newData)
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
        _vImageUrl = imageUrl.stringByReplacingOccurrencesOfString("100x100", withString: "600x600")
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
    
    
    
    
}