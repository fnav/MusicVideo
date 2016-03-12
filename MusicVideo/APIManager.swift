//
//  APIManager.swift
//  MusicVideo
//
//  Created by Francisco Navarro Madueño on 10/03/16.
//  Copyright © 2016 Francisco Navarro Madueño. All rights reserved.
//

import Foundation


class APIManager {

    
    func loadData(urlString:String, completion: (result:[Video])->Void){
        
        //config va a evitar que se guarden cosas en la cache
        let config = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        
        let session = NSURLSession(configuration: config)
        
        let url = NSURL(string: urlString)!
        
        //dataTaskWithURL se llevará a cabo en segundo plano (no en el hilo principal)-> de ahí que cuando nos de los datos tengamos que volver al hilo principal
        let task = session.dataTaskWithURL(url) { (data, response, error) -> Void in
            
            if error != nil {
                    print(error!.localizedDescription)
            }else{
                //print(data)
                do{
                    if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as? JSONDictionary,
                        feed = json["feed"] as? JSONDictionary,
                        entries = feed["entry"] as? JSONArray{
                    
                        var videos = [Video]()
                            for entry in entries{
                                let entry = Video(data: entry as! JSONDictionary)
                                videos.append(entry)
                            }
                        let i = videos.count
                        print("iTunesApiManager - total count --> \(i)")
                        print(" ")
                            
                        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                            dispatch_async(dispatch_get_global_queue(priority,0)){
                                dispatch_async(dispatch_get_main_queue()){
                                    completion(result: videos)
                                }
                            }
                    }
                }catch{
                    dispatch_async(dispatch_get_main_queue()){
                        print("error in NSJSONSerialization")
                    }
                    
                }
                
            }
        }
        
        task.resume()
    }
    
    
    
}