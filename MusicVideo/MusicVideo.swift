//
//  MusicVideo.swift
//  MusicVideo
//
//  Created by Francisco Navarro Madueño on 11/03/16.
//  Copyright © 2016 Francisco Navarro Madueño. All rights reserved.
//

import Foundation

class Video{
    
    //MARK: Structs
    //Struct with the API paths. It just indicates the path to find the necessary information
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
    
    //MARK: -
    //MARK: Private parameters

       //Image quality for videos. Get initial value from imageQuality in ViewController.
    //Everytime _vImageQuality is set we want to make sure _vImageUrl and vImageData is updated based on internet status
    private var _vImageQuality:ImageQualityType = imageQuality{
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
                _vImageUrl = _vImageUrl.stringByReplacingOccurrencesOfString(_vImageQuality.description, withString: newValue.description)
            case .best:
                if(_vImageQuality.rawValue == ImageQualityType.low.rawValue || _vImageQuality.rawValue == ImageQualityType.medium.rawValue){
                    //From .low or .medium to .best
                    //If we have already the photo saved with a good quality we don't want to reset de data.
                    if(_vImageData?.quality.rawValue != ImageQualityType.best.rawValue){
                        vImageData = nil
                    }
                }
                _vImageUrl = _vImageUrl.stringByReplacingOccurrencesOfString(_vImageQuality.description, withString: newValue.description)
            default:
                //Everytime _imageQuality is setted we'll change the _vImageUrl size
                _vImageUrl = _vImageUrl.stringByReplacingOccurrencesOfString(_vImageQuality.description, withString: newValue.description)
            }

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
    //private _vImageData will be use to store the qualityType of the NSData aldready loaded
    private var _vImageData:(data:NSData?,quality:ImageQualityType)?
 
    //MARK: -

    //Public vars
    //MARK: Public parameters
    
    //save video rank in iTunes
    var vRank = 0
    
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
    
    var vImageData:NSData?{
        didSet{
            _vImageData = (vImageData,_vImageQuality)
        }
    }
    
    //MARK: -
    //MARK: Class methods
    
    /*
     You don't need to know the logic of retrieveValueFromChain. It receives two values:
     - chain: a path where the data is located. For example: "im:releaseDate/attributes/label"
     - data: is the data where the method is suppose to find the data indicated in chain
     
     It returns the string value (if located) and empty string value (if not)
     */
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
    
    //MARK: -
    //MARK: Music Video Methods
    
    init (data: JSONDictionary){
        
        let datos: JSONDictionary = data
        //set imageName
        _vName = Video.retrieveValueFromChain(APIVideoConstants.imageName, data: datos)
        //set imageURL
        let imageUrl = Video.retrieveValueFromChain(APIVideoConstants.imageURL, data: data)
            //We'll put the size that MusicVideoBrain specify at the moment we load _vImage Url
        _vImageUrl = imageUrl.stringByReplacingOccurrencesOfString("100x100", withString:_vImageQuality.description)
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