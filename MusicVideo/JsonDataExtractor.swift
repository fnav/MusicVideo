//
//  JsonDataExtractor.swift
//  MusicVideo
//
//  Created by Francisco Navarro Madueño on 08/05/16.
//  Copyright © 2016 Francisco Navarro Madueño. All rights reserved.
//

import Foundation

class JsonDataExtractor {
    
    //MARK: -
    
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
    
    /*
     You don't need to know the logic of retrieveValueFromChain. It receives two values:
     - chain: a path where the data is located. For example: "im:releaseDate/attributes/label"
     - data: is the data where the method is suppose to find the data indicated in chain
     
     It returns the string value (if located) and empty string value (if not)
     */
    static func retrieveValueFromChain(chain:String, data:AnyObject)->String{
        
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

    
    static func extractVideoDataFromJson(videoDataObject: AnyObject) -> [Video] {
        
        guard let videoData = videoDataObject as? JSONDictionary else { return [Video]() }
        
        var videos = [Video]()
        
        if let feeds = videoData["feed"] as? JSONDictionary, entries = feeds["entry"] as? JSONArray {
            
            for (index, data) in entries.enumerate() {
                
                
                var vName = " ", vRights = "", vPrice = "", vImageUrl = "",
                vArtist = "", vVideoUrl = "", vImid = "", vGenre = "",
                vLinkToiTunes = "", vReleaseDte = ""
                
                //If data is a JSONDictionary set initial values for all video parameters
                if let datos: JSONDictionary = data as? JSONDictionary{
                        //set imageName
                        vName = JsonDataExtractor.retrieveValueFromChain(APIVideoConstants.imageName, data: datos)
                        //set imageURL
                        let imageUrl = JsonDataExtractor.retrieveValueFromChain(APIVideoConstants.imageURL, data: data)
                            //We'll put the size that MusicVideoBrain specify at the moment we load _vImage Url
                        vImageUrl = imageUrl.stringByReplacingOccurrencesOfString("100x100", withString:imageQuality.description)
                        //set videoURL
                        vVideoUrl = JsonDataExtractor.retrieveValueFromChain(APIVideoConstants.videoURL, data: data)
                        vRights = JsonDataExtractor.retrieveValueFromChain(APIVideoConstants.rights, data: data)
                        vPrice = JsonDataExtractor.retrieveValueFromChain(APIVideoConstants.price, data: data)
                        vArtist = JsonDataExtractor.retrieveValueFromChain(APIVideoConstants.artist, data: data)
                        vImid = JsonDataExtractor.retrieveValueFromChain(APIVideoConstants.iMid, data: data)
                        vGenre = JsonDataExtractor.retrieveValueFromChain(APIVideoConstants.genre, data: data)
                        vLinkToiTunes = JsonDataExtractor.retrieveValueFromChain(APIVideoConstants.linkToiTunes, data: data)
                        vReleaseDte = JsonDataExtractor.retrieveValueFromChain(APIVideoConstants.releaseDate, data: data)
                }
            
                
                let currentVideo = Video(vRank: index + 1, vName: vName, vRights: vRights, vPrice: vPrice, vImageUrl: vImageUrl, vArtist: vArtist, vVideoUrl: vVideoUrl, vImid: vImid, vGenre: vGenre, vLinkToiTunes: vLinkToiTunes, vReleaseDte: vReleaseDte,vImageQuality:imageQuality)
                
                videos.append(currentVideo)
                
                
            }
            
        }
        
        return videos
        
    }
}
