//
//  APIManager.swift
//  MusicVideo
//
//  Created by Francisco Navarro Madueño on 10/03/16.
//  Copyright © 2016 Francisco Navarro Madueño. All rights reserved.
//

import Foundation


class APIManager {

    
    func loadData(urlString:String, completion: (result:String)->Void){
        
        let config = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        
        let session = NSURLSession(configuration: config)
        
        let url = NSURL(string: urlString)!
        
        //dataTaskWithURL se llevará a cabo en segundo plano (no en el hilo principal)-> de ahí que cuando nos de los datos tengamos que volver al hilo principal
        let task = session.dataTaskWithURL(url) { (data, response, error) -> Void in
            
            dispatch_async(dispatch_get_main_queue()) {
                
                if error != nil{
                    completion(result: (error!.localizedDescription))
                }else{
                    completion(result: "NSURLSession successful")
                    print(data)
                }
            }
        }
        
        task.resume()
    }
    
    
    
}