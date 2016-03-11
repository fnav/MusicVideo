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
          static let ImageLabelName = "im:name"
          static let ImageLabel = "label"
          static let VideoImageName = "im:image"
          static let VideoLabel = "label"
          static let VideoUrlLink = "link"
          static let VideoUrlAtrributes = "attributes"
          static let VideoUrlHref = "href"
    }
    //Data encapsulation
    
    private var _vName:String
    private var _vImageUrl:String
    private var _vVideoUrl:String
    
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
    
    init (data: JSONDictionary){
        
        
        if let name = data[APIVideoConstants.ImageLabelName] as? JSONDictionary, vName = name[APIVideoConstants.ImageLabel] as? String{
            self._vName = vName
        }else{
            _vName = ""
        }
        
        if let img = data[APIVideoConstants.VideoImageName] as? JSONArray,
               image = img[2] as? JSONDictionary,
            immage = image[APIVideoConstants.VideoLabel] as? String{
                _vImageUrl = immage.stringByReplacingOccurrencesOfString("100x100", withString: "600x600")
                
        }else{
            _vImageUrl = ""
        }
        
        if let video = data[APIVideoConstants.VideoUrlLink] as? JSONArray,
               vUrl = video[1] as? JSONDictionary,
               vHref = vUrl[APIVideoConstants.VideoUrlAtrributes] as? JSONDictionary,
            vVideoUrl = vHref[APIVideoConstants.VideoUrlHref] as? String {
                self._vVideoUrl = vVideoUrl
        }else{
            _vVideoUrl = ""
        }
        
        
        
        
        
    }
    
    
    
    
}