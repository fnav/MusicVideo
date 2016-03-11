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
            
            if error != nil {
                dispatch_async(dispatch_get_main_queue()){
                    completion(result: error!.localizedDescription)
                }
            }else{
                //print(data)
                do{
                    if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as? [String: AnyObject]{
                    
                        print(json)
                        
                        let priority = DISPATCH_QUEUE_PRIORITY_HIGH
                        dispatch_async(dispatch_get_global_queue(priority, 0)){
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                completion(result: "JSONSerialization successful")
                            })
                        }
                        
                    }
                }catch{
                    dispatch_async(dispatch_get_main_queue()){
                        completion(result: "error in NSJSONSerialization")
                    }
                    
                }
                
            }
        }
        
        task.resume()
    }
    
    
    
}